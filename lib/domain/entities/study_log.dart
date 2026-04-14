class StudyLog {
  final int? id;
  final int categoryId;
  final int unitId;
  final int questionId;
  final bool isCorrect;
  final int sessionId;
  final int durationSeconds;
  final DateTime createdAt;

  StudyLog({
    this.id,
    required this.categoryId,
    required this.unitId,
    required this.questionId,
    required this.isCorrect,
    required this.sessionId,
    required this.durationSeconds,
    required this.createdAt,
  });
}
