import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnitScore', () {
    final cases = [
      (0, 0),
      (1, 1),
      (2, 1),
      (3, 2),
      (4, 2),
      (5, 3),
      (6, 3),
      (7, 4),
      (8, 4),
      (9, 4),
      (10, 5),
      (-1, 0),
      (11, 5),
    ];

    for (final (input, expected) in cases) {
      test('正解数: $input → ★: $expected', () {
        UnitScore a = UnitScore(categoryId: 1, unitId: 1, score: input);
        final result = a.stars;
        expect(result, expected);
      });
    }
  });
  test('isPerfect は correctCount が 10 のとき true', () {
    expect(UnitScore(categoryId: 1, unitId: 1, score: 10).isPerfect, true);
  });
  test('isPerfect は correctCount が 10 以外のとき false', () {
    expect(UnitScore(categoryId: 1, unitId: 1, score: 9).isPerfect, false);
    expect(UnitScore(categoryId: 1, unitId: 1, score: 0).isPerfect, false);
    expect(UnitScore(categoryId: 1, unitId: 1, score: 5).isPerfect, false);
    expect(UnitScore(categoryId: 1, unitId: 1, score: -1).isPerfect, false);
    expect(UnitScore(categoryId: 1, unitId: 1, score: 11).isPerfect, false);
    expect(UnitScore(categoryId: 1, unitId: 1, score: 8).isPerfect, false);
  });
}
