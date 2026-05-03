import 'package:flutter/material.dart';

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

class AnswersSet {
  final int id;
  final AnswerResult result;

  AnswersSet({
    required this.id,
    required this.result,
  });
}

class GameState {
  final GamePhase phase;
  final int categoryNo;
  final int unitNo;
  final int correctCount;
  final int currentIndex;
  final int combo;
  final int maxCombo;
  final int stars;
  final bool isCorrect;
  final bool isNewRecord;
  final List<AnswersSet> answers;

  const GameState({
    required this.phase,
    required this.categoryNo,
    required this.unitNo,
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
      categoryNo: 1,
      unitNo: 1,
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
  GameState printAnswers() {
    for (final answer in answers) {
      debugPrint("id: ${answer.id}, result: ${answer.result}");
    }
    return this;
  }

  GameState copyWith({
    GamePhase? phase,
    int? categoryNo,
    int? unitNo,
    int? correctCount,
    int? currentIndex,
    int? combo,
    int? maxCombo,
    int? stars,
    bool? isCorrect,
    bool? isNewRecord,
    List<AnswersSet>? answers,
  }) {
    return GameState(
      phase: phase ?? this.phase,
      categoryNo: categoryNo ?? this.categoryNo,
      unitNo: unitNo ?? this.unitNo,
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
