import 'package:flash_english/application/usecases/save_study_log_usecase.dart';
import 'package:flash_english/application/usecases/save_unit_score_usecase.dart';
import 'package:flash_english/domain/entities/study_log.dart';
import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/presentation/providers/study_log_provider.dart';
import 'package:flash_english/presentation/providers/training_provider.dart';
import 'package:flash_english/presentation/providers/unit_score_repository_provider.dart';
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

  GameController(this.ref)
      : saveStudyLogUseCase =
            SaveStudyLogUseCase(ref.read(studyLogRepositoryProvider)),
        saveUnitScoreUseCase =
            SaveUnitScoreUseCase(ref.read(unitScoreRepositoryProvider)),
        super(GameState.initial());
  bool _isDisposed = false;
  // ▶ スタート
  Future<void> start() async {
    state = state.copyWith(phase: GamePhase.loading);

    // 既存Providerで問題ロード
    await ref.read(trainingProvider.notifier).load();

    state = state.copyWith(
      phase: GamePhase.playing,
      currentIndex: 0,
      correctCount: 0,
      combo: 0,
      maxCombo: 0,
    );
  }

  // ▶ 回答
  Future<void> answer(int id, bool isCorrect) async {
    if (state.phase != GamePhase.playing) return;
    // ① 自分の状態更新
    final newCorrect = isCorrect ? state.correctCount + 1 : state.correctCount;

    final newCombo = isCorrect ? state.combo + 1 : 0;

    final newMaxCombo = newCombo > state.maxCombo ? newCombo : state.maxCombo;
    // final updatedAnswerSets = [...state.answers, answersSet];
    updateAnswers(id, isCorrect);

    state = state.copyWith(
      phase: GamePhase.feedback,
      correctCount: newCorrect,
      combo: newCombo,
      maxCombo: newMaxCombo,
      isCorrect: isCorrect,
      // answers: updatedAnswerSets,
    );

    // ② 既存Providerに保存させる（DB）
    await ref.read(trainingProvider.notifier).answer(isCorrect);

    // ③ 次へ or 終了
    await nextOrFinish(isCorrect);
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

  bool _isFinished() {
    const result = false;

    state.answers.length;
    if (state.answers.length >= 10) {
      return true;
    }
    return result;
  }

  void next() {
    final trainingNotifier = ref.read(trainingProvider.notifier);

    trainingNotifier.next(); // 表示を進める
    nextOrFinish(false); // ゲーム進行管理
  }

  // TODO: 次の問題へアルゴリズム
  // int _getLowestId() {
  //   int lowestId = 999;
  //   for (final answer in state.answers) {
  //     if (answer.id < lowestId) {
  //       lowestId = answer.id;
  //     }
  //   }
  //   return lowestId;
  // }

  // int _getNextEmptyId(int currentId) {
  //   for (int i = currentId + 1; i < 10; i++) {
  //     bool isExist = false;
  //     for (final answer in state.answers) {
  //       if (answer.id == i) {
  //         isExist = true;
  //         break;
  //       }
  //     }
  //     if (!isExist) {
  //       return i;
  //     }
  //   }
  //   return -1;
  // }

  // int _getNextId(int currentId) {
  //   if (currentId >= 10) {
  //     return _getLowestId();
  //   }
  //   return _getNextEmptyId(currentId);
  // }

  Future<void> nextOrFinish(bool isCorrect) async {
    await Future.delayed(const Duration(milliseconds: 700));
    debugPrint("nextOrFinish called");
    final trainingState = ref.read(trainingProvider);
    final studyLog = StudyLog(
      categoryId: 1, // TODO: カテゴリID
      unitId: 1, // TODO: ユニットID
      questionId: trainingState.current.id ?? 0, // TODO: 問題ID
      isCorrect: isCorrect,
      sessionId: trainingState.sessionId ?? 1, // TODO: セッションID
      durationSeconds: 60, // TODO: 勉強時間
      createdAt: DateTime.now(), // TODO: 作成日時
    );

    state.printAnswers();
    // final isLast =
    //     trainingState.currentIndex >= trainingState.questions.length - 1;
    final isFinihed = _isFinished();
    if (isFinihed) {
      debugPrint("nextOrFinish 終了へ行きます。");
      debugPrint(
          "DBに保存します： 正解？ ${state.isCorrect}, questionId: ${state.currentIndex}");
      final success = await saveStudyLogUseCase.execute(studyLog);
      debugPrint("保存したよ。$success");
      _finish();
    } else {
      debugPrint(
          "nextOrFinish 次へ行きます。currentIndex: ${trainingState.currentIndex}");
      // study_logをDBに保存するAPIを叩く
      debugPrint(
          "DBに保存します： 正解？ ${state.isCorrect}, questionId: ${state.currentIndex}");
      final success = await saveStudyLogUseCase.execute(studyLog);
      debugPrint("保存したよ。$success");
      // Future.delayed(const Duration(milliseconds: 300), () {
      //   state = state.copyWith(phase: GamePhase.finished);
      // });
      state = state.copyWith(
        phase: GamePhase.playing,
        currentIndex: trainingState.currentIndex,
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // ▶ 終了処理
  Future<void> _finish() async {
    final score = state.correctCount;
    final unitScore = UnitScore(
      categoryId: state.categoryId,
      unitId: state.unitId,
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
    debugPrint("unit score DBに保存します： 正解？ ${state.isCorrect}");
    final success = await saveUnitScoreUseCase.saveAPI(unitScore);
    debugPrint("保存したよ。$success");

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_isDisposed) return;
      state = state.copyWith(phase: GamePhase.finished);
    });
  }

  // ▶ リトライ
  Future<void> retry() async {
    state = GameState.initial();
    await start();
  }

  // ▶ ベスト判定（仮）
  bool _isNewRecord(int stars) {
    // TODO: DB連携
    const best = 3;
    return stars > best;
  }
}
