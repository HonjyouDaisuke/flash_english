class StudyLog {
  final int? id;
  final int questionId;
  final bool isCorrect;
  final DateTime createdAt;
  final int sessionId;
  final int durationSeconds;

  StudyLog({
    this.id,
    required this.questionId,
    required this.isCorrect,
    required this.createdAt,
    required this.sessionId,
    required this.durationSeconds,
  });
}
