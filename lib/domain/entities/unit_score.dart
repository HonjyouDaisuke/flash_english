class UnitScore {
  final int categoryId;
  final int unitId;
  final int score;

  UnitScore({
    required this.categoryId,
    required this.unitId,
    required this.score,
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
}
