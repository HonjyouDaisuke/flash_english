class StudyLog {
  final String? id;
  final int questionId;
  final int categoryNo;
  final int unitNo;
  final int questionNo;
  final bool isCorrect;
  final int sessionId;
  final int durationSeconds;
  final DateTime createdAt;

  StudyLog({
    this.id,
    required this.questionId,
    required this.categoryNo,
    required this.unitNo,
    required this.questionNo,
    required this.isCorrect,
    required this.sessionId,
    required this.durationSeconds,
    required this.createdAt,
  });

  factory StudyLog.fromJson(Map<String, dynamic> json) {
    return StudyLog(
      id: json['id'] as String?,
      questionId: (json['question_id'] as num?)?.toInt() ?? 0,
      categoryNo: (json['category_no'] as num?)?.toInt() ?? 0,
      unitNo: (json['unit_no'] as num?)?.toInt() ?? 0,
      questionNo: (json['question_no'] as num?)?.toInt() ?? 0,
      isCorrect: (json['is_correct'] as num?)?.toInt() == 1,
      sessionId: (json['session_id'] as num?)?.toInt() ?? 0,
      durationSeconds: (json['duration'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'category_no': categoryNo,
      'unit_no': unitNo,
      'question_no': questionNo,
      'is_correct': isCorrect,
      'session_id': sessionId,
      'duration': durationSeconds,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': questionId,
      'category_no': categoryNo,
      'unit_no': unitNo,
      'question_no': questionNo,
      'is_correct': isCorrect ? 1 : 0,
      'session_id': sessionId,
      'duration': durationSeconds,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
