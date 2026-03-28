import 'package:flash_english/application/usecases/play_audio_usecase.dart';
import 'package:flash_english/presentation/providers/audio_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/application/usecases/get_questions_usecase.dart';
import 'package:flash_english/infrastructure/repositories/question_repository_impl.dart';

final trainingProvider =
    StateNotifierProvider<TrainingNotifier, TrainingState>((ref) {
  final repo = QuestionRepositoryImpl();
  final getQ = GetQuestionsUseCase(repo);
  final audioRepo = ref.read(audioRepositoryProvider);
  final playAudio = PlayAudioUseCase(audioRepo);
  return TrainingNotifier(getQ, playAudio);
});

class TrainingState {
  final List<Question> questions;
  final int currentIndex;
  final bool isFront;
  final bool isLoading;

  const TrainingState({
    this.questions = const [],
    this.currentIndex = 0,
    this.isFront = true,
    this.isLoading = true,
  });

  Question get current => questions[currentIndex];

  TrainingState copyWith({
    List<Question>? questions,
    int? currentIndex,
    bool? isFront,
    bool? isLoading,
  }) {
    return TrainingState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      isFront: isFront ?? this.isFront,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TrainingNotifier extends StateNotifier<TrainingState> {
  final GetQuestionsUseCase _usecase;
  final PlayAudioUseCase _audio;

  TrainingNotifier(this._usecase, this._audio) : super(const TrainingState());

  Future<void> load() async {
    final q = await _usecase.execute();

    state = state.copyWith(
      questions: q,
      isLoading: false,
    );
    await playFront();
  }

  Future<void> playFront() async {
    final q = state.current;
    await _audio.execute(q.japaneseAudio!);
  }

  Future<void> playBack() async {
    final q = state.current;
    await _audio.execute(q.englishAudio!);
  }

  Future<void> playCurrent() async {
    if (state.isFront) {
      await playFront();
    } else {
      await playBack();
    }
  }

  void next() async {
    if (state.currentIndex >= state.questions.length - 1) return;

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      isFront: true,
    );

    await playFront();
  }

  void prev() async {
    if (state.currentIndex <= 0) return;

    state = state.copyWith(
      currentIndex: state.currentIndex - 1,
      isFront: true,
    );

    await playFront();
  }

  void flip(bool isFront) async {
    state = state.copyWith(isFront: isFront);
    await playCurrent();
  }
}
