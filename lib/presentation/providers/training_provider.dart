import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/application/usecases/get_questions_usecase.dart';
import 'package:flash_english/infrastructure/repositories/question_repository_impl.dart';

final trainingProvider =
    StateNotifierProvider<TrainingNotifier, TrainingState>((ref) {
  final repo = QuestionRepositoryImpl();
  final usecase = GetQuestionsUseCase(repo);
  return TrainingNotifier(usecase);
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

  TrainingNotifier(this._usecase) : super(const TrainingState());

  Future<void> load() async {
    final q = await _usecase.execute();

    state = state.copyWith(
      questions: q,
      isLoading: false,
    );
  }

  void next() {
    if (state.currentIndex >= state.questions.length - 1) return;

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      isFront: true,
    );
  }

  void prev() {
    if (state.currentIndex <= 0) return;

    state = state.copyWith(
      currentIndex: state.currentIndex - 1,
      isFront: true,
    );
  }

  void flip(bool isFront) {
    state = state.copyWith(isFront: isFront);
  }
}
