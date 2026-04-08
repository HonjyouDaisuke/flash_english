enum GamePhase {
  ready,
  loading,
  playing,
  feedback,
  result,
  finished,
}

enum AnswerResult {
  correct,
  wrong,
  skip,
}

class GameState {
  final GamePhase phase;
  final int correctCount;
  final int currentIndex;
  final int combo;
  final int maxCombo;
  final int stars;
  final bool isCorrect;
  final bool isNewRecord;
  final List<AnswerResult> answers;

  const GameState({
    required this.phase,
    required this.correctCount,
    required this.currentIndex,
    required this.combo,
    required this.maxCombo,
    required this.stars,
    required this.isCorrect,
    required this.isNewRecord,
    required this.answers,
  });

  factory GameState.initial() {
    return const GameState(
      phase: GamePhase.ready,
      correctCount: 0,
      currentIndex: 0,
      combo: 0,
      maxCombo: 0,
      stars: 0,
      isCorrect: false,
      isNewRecord: false,
      answers: [],
    );
  }

  GameState copyWith({
    GamePhase? phase,
    int? correctCount,
    int? currentIndex,
    int? combo,
    int? maxCombo,
    int? stars,
    bool? isCorrect,
    bool? isNewRecord,
    List<AnswerResult>? answers,
  }) {
    return GameState(
      phase: phase ?? this.phase,
      correctCount: correctCount ?? this.correctCount,
      currentIndex: currentIndex ?? this.currentIndex,
      combo: combo ?? this.combo,
      maxCombo: maxCombo ?? this.maxCombo,
      stars: stars ?? this.stars,
      isCorrect: isCorrect ?? this.isCorrect,
      isNewRecord: isNewRecord ?? this.isNewRecord,
      answers: answers ?? this.answers,
    );
  }
}
