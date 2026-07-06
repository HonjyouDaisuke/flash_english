import 'package:flash_english/application/usecases/download_unit_audio_usecase.dart';
import 'package:flash_english/application/usecases/enqueue_study_log_usecase.dart';
import 'package:flash_english/application/usecases/enqueue_unit_score_usecase.dart';
import 'package:flash_english/application/usecases/save_study_log_usecase.dart';
import 'package:flash_english/application/usecases/save_unit_score_usecase.dart';
import 'package:flash_english/core/constants/user_setting_keys.dart';
import 'package:flash_english/domain/entities/auth_status.dart';
import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/presentation/controllers/questions_controller.dart';
import 'package:flash_english/presentation/providers/audio_repository_provider.dart';
import 'package:flash_english/presentation/providers/auth_provider.dart';
import 'package:flash_english/presentation/providers/study_log_provider.dart';
import 'package:flash_english/presentation/providers/sync_queue_provider.dart';
import 'package:flash_english/presentation/providers/training_provider.dart';
import 'package:flash_english/presentation/providers/unit_score_repository_provider.dart';
import 'package:flash_english/presentation/providers/unit_scores_provider.dart';
import 'package:flash_english/presentation/providers/user_settings_repository_provider.dart';
import 'package:flash_english/presentation/states/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final gameControllerProvider =
    StateNotifierProvider.autoDispose<GameController, GameState>((ref) {
  return GameController(ref);
});

class GameController extends StateNotifier<GameState> {
  final Ref ref;
  final SaveStudyLogUseCase saveStudyLogUseCase;
  final SaveUnitScoreUseCase saveUnitScoreUseCase;
  final EnqueueStudyLogUseCase enqueueStudyLogUseCase;
  final EnqueueUnitScoreUseCase enqueueUnitScoreUseCase;
  final DownloadUnitAudioUseCase downloadUnitAudioUseCase;
  final QuestionsController questionsController = QuestionsController();

  GameController(this.ref)
      : saveStudyLogUseCase =
            SaveStudyLogUseCase(ref.read(studyLogRepositoryProvider)),
        enqueueStudyLogUseCase = EnqueueStudyLogUseCase(ref.read(
          syncQueueRepositoryProvider,
        )),
        saveUnitScoreUseCase =
            SaveUnitScoreUseCase(ref.read(unitScoreRepositoryProvider)),
        enqueueUnitScoreUseCase = EnqueueUnitScoreUseCase(ref.read(
          syncQueueRepositoryProvider,
        )),
        downloadUnitAudioUseCase =
            DownloadUnitAudioUseCase(ref.read(audioDownloadRepositoryProvider)),
        super(GameState.initial());
  bool _isDisposed = false;
  // ▶ スタート
  Future<void> start({
    required int categoryNo,
    required int unitNo,
  }) async {
    state = state.copyWith(phase: GamePhase.loading);
    final questionOrder = await ref
        .read(userSettingsRepositoryProvider)
        .getString(UserSettingKeys.questionOrder);
    final isRandom = questionOrder == 'random';

    try {
      await downloadUnitAudioUseCase.execute(
        categoryNo,
        unitNo,
      );
    } catch (e, st) {
      debugPrint('audio download failed: $e');
      debugPrintStack(stackTrace: st);
      // TODO: エラーphaseがあるなら遷移。なければ呼び出し元へ通知しUIでハンドリング。
      rethrow;
    }
    // 既存Providerで問題ロード
    await ref.read(trainingProvider.notifier).load(categoryNo, unitNo);

    final first = questionsController.start(isRandom: isRandom);

    ref.read(trainingProvider.notifier).moveToQuestion(first);

    state = state.copyWith(
      phase: GamePhase.playing,
      currentIndex: 0,
      correctCount: 0,
      categoryNo: categoryNo,
      unitNo: unitNo,
      combo: 0,
      maxCombo: 0,
    );
  }

  Future<void> _moveToNextQuestion() async {
    final nextQuestion = questionsController.markAnswered();

    if (nextQuestion == null) {
      await _finish();
      return;
    }

    ref.read(trainingProvider.notifier).moveToQuestion(nextQuestion);
  }

  // ▶ 回答
  Future<void> answer(int id, bool isCorrect) async {
    if (state.phase != GamePhase.playing) return;
    // ① 自分の状態更新
    final newCorrect = isCorrect ? state.correctCount + 1 : state.correctCount;

    final newCombo = isCorrect ? state.combo + 1 : 0;

    final newMaxCombo = newCombo > state.maxCombo ? newCombo : state.maxCombo;

    updateAnswers(id, isCorrect);

    state = state.copyWith(
      correctCount: newCorrect,
      combo: newCombo,
      maxCombo: newMaxCombo,
      isCorrect: isCorrect,
      // answers: updatedAnswerSets,
    );
    await ref.read(trainingProvider.notifier).saveAnswer(isCorrect);

    await _moveToNextQuestion();
  }

  void updateAnswers(int id, bool isCorrect) {
    final result = isCorrect ? AnswerResult.correct : AnswerResult.wrong;
    final answersSet = AnswersSet(id: id, result: result);
    final existingIndex = state.answers.indexWhere((a) => a.id == id);

    if (existingIndex != -1) {
      debugPrint("updateAnswers: 上書きします。id: $id, result: $result");
      final updatedAnswers = [...state.answers];
      updatedAnswers[existingIndex] = answersSet;
      state = state.copyWith(answers: updatedAnswers);
    } else {
      final updatedAnswerSets = [...state.answers, answersSet];
      state = state.copyWith(answers: updatedAnswerSets);
    }
  }

  Future<void> next() async {
    final no = questionsController.next();

    if (no == null) {
      await _finish();
      return;
    }

    ref.read(trainingProvider.notifier).moveToQuestion(no);
  }

  void prev() {
    final no = questionsController.prev();

    if (no == null) return;

    ref.read(trainingProvider.notifier).moveToQuestion(no);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // ▶ 終了処理
  Future<void> _finish() async {
    final score = state.correctCount;
    final auth = ref.read(authProvider);
    final unitScore = UnitScore(
      categoryNo: state.categoryNo,
      unitNo: state.unitNo,
      score: score,
      achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()),
    );
    final stars = unitScore.stars;
    final isNew = _isNewRecord(stars);

    state = state.copyWith(
      phase: GamePhase.result,
      stars: stars,
      isNewRecord: isNew,
    );

    // DB保存
    debugPrint("unit score を loaclDBに保存します");
    await saveUnitScoreUseCase.saveLocal(unitScore);
    await enqueueUnitScoreUseCase.call(
        unitScore, ref.read(authProvider).userId!);
    ref.invalidate(unitScoresProvider(state.categoryNo));
    await Future.delayed(const Duration(milliseconds: 300));
    if (_isDisposed) return;
    state = state.copyWith(phase: GamePhase.finished);

    if (auth.status == AuthStatus.onlineAuthenticated && auth.userId != null) {
      try {
        await ref.read(syncQueueUseCaseProvider).execute(auth.userId!);
        debugPrint("ローカルのキューをサーバーに同期完了");
      } catch (e) {
        debugPrint("キュー同期失敗: $e");
      }
    }
  }

  // ▶ リトライ
  Future<void> retry({
    required int categoryNo,
    required int unitNo,
  }) async {
    state = GameState.initial();
    await start(categoryNo: categoryNo, unitNo: unitNo);
  }

  // ▶ ベスト判定（仮）
  bool _isNewRecord(int stars) {
    // TODO: DB連携
    const best = 3;
    return stars > best;
  }
}
