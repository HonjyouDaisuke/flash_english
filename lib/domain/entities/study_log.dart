class StudyLog {
  final int? id;
  final int categoryNo;
  final int unitNo;
  final int questionNo;
  final bool isCorrect;
  final int sessionId;
  final int durationSeconds;
  final DateTime createdAt;

  StudyLog({
    this.id,
    required this.categoryNo,
    required this.unitNo,
    required this.questionNo,
    required this.isCorrect,
    required this.sessionId,
    required this.durationSeconds,
    required this.createdAt,
  });
}
