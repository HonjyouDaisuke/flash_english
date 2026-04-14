class UnitScore {
  final int correctCount;

  UnitScore(this.correctCount);

  int get stars {
    if (correctCount > 10) return 5;
    if (correctCount == 10) return 5;
    if (correctCount >= 7) return 4;
    if (correctCount >= 5) return 3;
    if (correctCount >= 3) return 2;
    if (correctCount >= 1) return 1;
    return 0;
  }

  bool get isPerfect => correctCount == 10;
}
