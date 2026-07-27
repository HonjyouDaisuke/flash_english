class StudyLog {
  final int? id;
  final int questionId;
  final bool isCorrect;
  final int sessionId;
  final int durationSeconds;
  final DateTime createdAt;

  StudyLog({
    this.id,
    required this.questionId,
    required this.isCorrect,
    required this.sessionId,
    required this.durationSeconds,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'is_correct': isCorrect,
      'session_id': sessionId,
      'duration': durationSeconds,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
