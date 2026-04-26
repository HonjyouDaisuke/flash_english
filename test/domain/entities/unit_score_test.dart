import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

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
        UnitScore a = UnitScore(
            categoryId: 1,
            unitId: 1,
            score: input,
            achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()));
        final result = a.stars;
        expect(result, expected);
      });
    }
  });
  test('isPerfect は correctCount が 10 のとき true', () {
    expect(
        UnitScore(
                categoryId: 1,
                unitId: 1,
                score: 10,
                achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()))
            .isPerfect,
        true);
  });
  test('isPerfect は correctCount が 10 以外のとき false', () {
    expect(
        UnitScore(
                categoryId: 1,
                unitId: 1,
                score: 9,
                achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()))
            .isPerfect,
        false);
    expect(
        UnitScore(
                categoryId: 1,
                unitId: 1,
                score: 0,
                achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()))
            .isPerfect,
        false);
    expect(
        UnitScore(
                categoryId: 1,
                unitId: 1,
                score: 5,
                achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()))
            .isPerfect,
        false);
    expect(
        UnitScore(
                categoryId: 1,
                unitId: 1,
                score: -1,
                achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()))
            .isPerfect,
        false);
    expect(
        UnitScore(
                categoryId: 1,
                unitId: 1,
                score: 11,
                achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()))
            .isPerfect,
        false);
    expect(
        UnitScore(
                categoryId: 1,
                unitId: 1,
                score: 8,
                achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()))
            .isPerfect,
        false);
  });
}
