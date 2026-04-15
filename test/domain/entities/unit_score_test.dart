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
        final result = UnitScore(input).stars;
        expect(result, expected);
      });
    }
  });
  test('isPerfect は correctCount が 10 のとき true', () {
    expect(UnitScore(10).isPerfect, true);
  });
  test('isPerfect は correctCount が 10 以外のとき false', () {
    expect(UnitScore(9).isPerfect, false);
    expect(UnitScore(0).isPerfect, false);
    expect(UnitScore(5).isPerfect, false);
    expect(UnitScore(-1).isPerfect, false);
    expect(UnitScore(11).isPerfect, false);
    expect(UnitScore(8).isPerfect, false);
  });
}
