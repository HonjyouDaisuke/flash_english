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
        final a = UnitScore(
          categoryId: 1,
          unitId: 1,
          score: input,
          achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()),
        );

        expect(a.stars, expected);
      });
    }

    test('isPerfect は score が 10 のとき true', () {
      expect(
        UnitScore(
          categoryId: 1,
          unitId: 1,
          score: 10,
          achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()),
        ).isPerfect,
        true,
      );
    });

    test('isPerfect は score が 10 以外のとき false', () {
      final values = [9, 0, 5, -1, 11, 8];

      for (final value in values) {
        expect(
          UnitScore(
            categoryId: 1,
            unitId: 1,
            score: value,
            achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()),
          ).isPerfect,
          false,
        );
      }
    });
  });

  group('UnitScore.fromJson', () {
    test('正常値を変換できる', () {
      final json = {
        'category_id': 3,
        'unit_id': 7,
        'high_score': 9,
        'achieved_at': '2026/04/29',
      };

      final result = UnitScore.fromJson(json);

      expect(result.categoryId, 3);
      expect(result.unitId, 7);
      expect(result.score, 9);
      expect(result.achievedAt, '2026/04/29');
    });

    test('double型の数値も int に変換できる', () {
      final json = {
        'category_id': 1.0,
        'unit_id': 2.0,
        'high_score': 10.0,
        'achieved_at': '2026/04/29',
      };

      final result = UnitScore.fromJson(json);

      expect(result.categoryId, 1);
      expect(result.unitId, 2);
      expect(result.score, 10);
    });

    test('null の場合はデフォルト値になる', () {
      final json = {
        'category_id': null,
        'unit_id': null,
        'high_score': null,
        'achieved_at': null,
      };

      final result = UnitScore.fromJson(json);

      expect(result.categoryId, 0);
      expect(result.unitId, 0);
      expect(result.score, 0);
      expect(result.achievedAt, '');
    });

    test('キーが存在しない場合もデフォルト値になる', () {
      final json = <String, dynamic>{};

      final result = UnitScore.fromJson(json);

      expect(result.categoryId, 0);
      expect(result.unitId, 0);
      expect(result.score, 0);
      expect(result.achievedAt, '');
    });

    test('fromJson 後も stars が正しく計算される', () {
      final json = {
        'category_id': 1,
        'unit_id': 1,
        'high_score': 7,
        'achieved_at': '2026/04/29',
      };

      final result = UnitScore.fromJson(json);

      expect(result.stars, 4);
    });

    test('fromJson 後も isPerfect が正しく計算される', () {
      final json = {
        'category_id': 1,
        'unit_id': 1,
        'high_score': 10,
        'achieved_at': '2026/04/29',
      };

      final result = UnitScore.fromJson(json);

      expect(result.isPerfect, true);
    });
  });
}
