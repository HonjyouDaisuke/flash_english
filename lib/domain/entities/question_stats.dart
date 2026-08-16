class QuestionStats {
  final int questionId;
  final int categoryNo;
  final int unitNo;
  final int questionNo;
  final int correctCount;
  final int wrongCount;
  final DateTime createdAt;

  QuestionStats({
    required this.questionId,
    required this.categoryNo,
    required this.unitNo,
    required this.questionNo,
    required this.correctCount,
    required this.wrongCount,
    required this.createdAt,
  });

  factory QuestionStats.fromJson(Map<String, dynamic> json) {
    return QuestionStats(
      questionId: (json['question_id'] as num).toInt(),
      categoryNo: (json['category_no'] as num).toInt(),
      unitNo: (json['unit_no'] as num).toInt(),
      questionNo: (json['question_no'] as num).toInt(),
      correctCount: (json['correct_count'] as num).toInt(),
      wrongCount: (json['wrong_count'] as num).toInt(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'category_no': categoryNo,
      'unit_no': unitNo,
      'question_no': questionNo,
      'correct_count': correctCount,
      'wrong_count': wrongCount,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
