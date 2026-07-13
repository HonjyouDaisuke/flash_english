import 'package:flash_english/application/usecases/end_session_usecase.dart';
import 'package:flash_english/application/usecases/play_audio_usecase.dart';
import 'package:flash_english/application/usecases/save_answer_usecase.dart';
import 'package:flash_english/application/usecases/start_session_usecase.dart';
import 'package:flash_english/infrastructure/repositories/study_repository_impl.dart';
import 'package:flash_english/presentation/providers/api_client_provider.dart';
import 'package:flash_english/presentation/providers/audio/audio_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/application/usecases/get_questions_usecase.dart';
import 'package:flash_english/infrastructure/repositories/question_repository_impl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

final trainingProvider =
    StateNotifierProvider.autoDispose<TrainingNotifier, TrainingState>((ref) {
  final repo = QuestionRepositoryImpl(ref.read(apiClientProvider));
  final getQ = GetQuestionsUseCase(repo);
  final audioRepo = ref.read(audioPlayerRepositoryProvider);
  final playAudio = PlayAudioUseCase(audioRepo);
  final studyRepo = StudyRepositoryImpl();

  final notifier = TrainingNotifier(
    getQ,
    playAudio,
    StartSessionUseCase(studyRepo),
    EndSessionUseCase(studyRepo),
    SaveAnswerUseCase(studyRepo),
  );
  ref.onDispose(() {
    notifier.endSession();
  });
  return notifier;
});

class TrainingState {
  final List<Question> questions;
  final int currentIndex;
  final bool isFront;
  final bool isLoading;
  final int? sessionId;

  const TrainingState({
    this.questions = const [],
    this.currentIndex = 0,
    this.isFront = true,
    this.isLoading = true,
    this.sessionId,
  });

  Question get current => questions[currentIndex];

  TrainingState copyWith({
    List<Question>? questions,
    int? currentIndex,
    bool? isFront,
    bool? isLoading,
    int? sessionId,
  }) {
    return TrainingState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      isFront: isFront ?? this.isFront,
      isLoading: isLoading ?? this.isLoading,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

class TrainingNotifier extends StateNotifier<TrainingState> {
  final GetQuestionsUseCase _usecase;
  final PlayAudioUseCase _audio;
  final StartSessionUseCase _startSession;
  final EndSessionUseCase _endSession;
  final SaveAnswerUseCase _saveAnswer;

  TrainingNotifier(
    this._usecase,
    this._audio,
    this._startSession,
    this._endSession,
    this._saveAnswer,
  ) : super(const TrainingState());

  Future<void> load(int categoryNo, int unitNo) async {
    debugPrint("🔥 LOAD START");

    final q = await _usecase.execute(categoryNo, unitNo);
    debugPrint("✅ QUESTIONS: ${q.length}");

    final sessionId = await _startSession.execute();
    debugPrint("🟡 SESSION: $sessionId");

    state = state.copyWith(
      questions: q,
      isLoading: false,
      sessionId: sessionId,
    );

    debugPrint("🟢 STATE UPDATED");
  }

  Future<void> endSession() async {
    if (state.sessionId == null) return;

    await _endSession.execute(state.sessionId!);
  }

  @override
  void dispose() {
    endSession(); // 👈 ここで終了
    super.dispose();
  }

  void setSession(int id) {
    state = state.copyWith(sessionId: id);
  }

  Future<void> playFront() async {
    final q = state.current;
    final dir = await getApplicationDocumentsDirectory();

    final safeFileName = p.basename(q.japaneseAudio);
    final path = p.join(
      dir.path,
      'audio',
      'unit_${q.categoryNo.toString().padLeft(2, '0')}_${q.unitNo.toString().padLeft(2, '0')}',
      safeFileName,
    );
    debugPrint("日本語音声:${q.japaneseAudio}");
    await _audio.execute(path);
  }

  Future<void> playBack() async {
    final q = state.current;
    final dir = await getApplicationDocumentsDirectory();

    final path = '${dir.path}/audio/'
        'unit_${q.categoryNo.toString().padLeft(2, '0')}_'
        '${q.unitNo.toString().padLeft(2, '0')}/'
        '${q.englishAudio}';
    debugPrint("英語音声:$path");
    await _audio.execute(path);
  }

  Future<void> playCurrent() async {
    if (state.isFront) {
      await playFront();
    } else {
      await playBack();
    }
  }

  Future<void> playFrontAndWait() async {
    final q = state.current;
    final dir = await getApplicationDocumentsDirectory();

    final path = '${dir.path}/audio/'
        'unit_${q.categoryNo.toString().padLeft(2, '0')}_'
        '${q.unitNo.toString().padLeft(2, '0')}/'
        '${q.japaneseAudio}';
    debugPrint("日本語音声(待ち):$path");
    await _audio.execute(path);
  }

  void moveToQuestion(int questionNo) {
    final index = state.questions.indexWhere(
      (q) => q.number == questionNo,
    );

    if (index == -1) return;

    state = state.copyWith(
      currentIndex: index,
      isFront: true,
    );
  }

  Future<void> saveAnswer(bool isCorrect) async {
    final q = state.current;

    if (state.sessionId == null) return;

    await _saveAnswer.execute(
      questionNo: q.questionId,
      isCorrect: isCorrect,
      sessionId: state.sessionId!,
    );
  }

  void flip(bool isFront) async {
    state = state.copyWith(isFront: isFront);
    await playCurrent();
  }
}
