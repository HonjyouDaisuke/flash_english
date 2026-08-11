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
    if (!json.containsKey('question_id')) {
      throw const FormatException('Missing question_id');
    }
    if (!json.containsKey('category_no')) {
      throw const FormatException('Missing category_no');
    }
    if (!json.containsKey('unit_no')) {
      throw const FormatException('Missing unit_no');
    }
    if (!json.containsKey('question_no')) {
      throw const FormatException('Missing question_no');
    }
    return StudyLog(
      id: json['id'] as String?,
      questionId: (json['question_id'] as num).toInt(),
      categoryNo: (json['category_no'] as num).toInt(),
      unitNo: (json['unit_no'] as num).toInt(),
      questionNo: (json['question_no'] as num).toInt(),
      isCorrect: (json['is_correct'] as num).toInt() == 1,
      sessionId: (json['session_id'] as num).toInt(),
      durationSeconds: (json['duration_seconds'] as num).toInt(),
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
      'duration_seconds': durationSeconds,
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
      'duration_seconds': durationSeconds,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
