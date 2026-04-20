class UnitScore {
  final int categoryId;
  final int unitId;
  final int score;
  final String achievedAt;

  UnitScore({
    required this.categoryId,
    required this.unitId,
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
      categoryId: json['category_id'],
      unitId: json['unit_id'],
      score: json['high_score'],
      achievedAt: json['achieved_at'],
    );
  }
}
