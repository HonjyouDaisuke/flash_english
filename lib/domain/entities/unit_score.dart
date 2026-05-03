class UnitScore {
  final int categoryNo;
  final int unitNo;
  final int score;
  final String achievedAt;

  UnitScore({
    required this.categoryNo,
    required this.unitNo,
    required this.score,
    required this.achievedAt,
  });

  int get stars {
    if (score > 10) return 5;
    if (score == 10) return 5;
    if (score >= 7) return 4;
    if (score >= 5) return 3;
    if (score >= 3) return 2;
    if (score >= 1) return 1;
    return 0;
  }

  bool get isPerfect => score == 10;

  factory UnitScore.fromJson(Map<String, dynamic> json) {
    return UnitScore(
      categoryNo: (json['category_no'] as num?)?.toInt() ?? 0,
      unitNo: (json['unit_no'] as num?)?.toInt() ?? 0,
      score: (json['high_score'] as num?)?.toInt() ?? 0,
      achievedAt: (json['achieved_at'] as String?) ?? '',
    );
  }
}
