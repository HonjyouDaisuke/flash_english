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
          categoryNo: 1,
          unitNo: 1,
          score: input,
          achievedAt: DateFormat('yyyy/MM/dd').format(DateTime.now()),
        );

        expect(a.stars, expected);
      });
    }

    test('isPerfect は score が 10 のとき true', () {
      expect(
        UnitScore(
          categoryNo: 1,
          unitNo: 1,
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
            categoryNo: 1,
            unitNo: 1,
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
        'category_no': 3,
        'unit_no': 7,
        'high_score': 9,
        'achieved_at': '2026/04/29',
      };

      final result = UnitScore.fromJson(json);

      expect(result.categoryNo, 3);
      expect(result.unitNo, 7);
      expect(result.score, 9);
      expect(result.achievedAt, '2026/04/29');
    });

    test('double型の数値も int に変換できる', () {
      final json = {
        'category_no': 1.0,
        'unit_no': 2.0,
        'high_score': 10.0,
        'achieved_at': '2026/04/29',
      };

      final result = UnitScore.fromJson(json);

      expect(result.categoryNo, 1);
      expect(result.unitNo, 2);
      expect(result.score, 10);
    });

    test('null の場合はデフォルト値になる', () {
      final json = {
        'category_no': null,
        'unit_no': null,
        'high_score': null,
        'achieved_at': null,
      };

      final result = UnitScore.fromJson(json);

      expect(result.categoryNo, 0);
      expect(result.unitNo, 0);
      expect(result.score, 0);
      expect(result.achievedAt, '');
    });

    test('キーが存在しない場合もデフォルト値になる', () {
      final json = <String, dynamic>{};

      final result = UnitScore.fromJson(json);

      expect(result.categoryNo, 0);
      expect(result.unitNo, 0);
      expect(result.score, 0);
      expect(result.achievedAt, '');
    });

    test('fromJson 後も stars が正しく計算される', () {
      final json = {
        'category_no': 1,
        'unit_no': 1,
        'high_score': 7,
        'achieved_at': '2026/04/29',
      };

      final result = UnitScore.fromJson(json);

      expect(result.stars, 4);
    });

    test('fromJson 後も isPerfect が正しく計算される', () {
      final json = {
        'category_no': 1,
        'unit_no': 1,
        'high_score': 10,
        'achieved_at': '2026/04/29',
      };

      final result = UnitScore.fromJson(json);

      expect(result.isPerfect, true);
    });
  });

  group('UnitScore.toJson', () {
    test('正しく JSON に変換できる', () {
      final unitScore = UnitScore(
        categoryNo: 2,
        unitNo: 5,
        score: 8,
        achievedAt: '2026/05/24',
      );

      final json = unitScore.toJson();

      expect(json['category_no'], 2);
      expect(json['unit_no'], 5);
      expect(json['high_score'], 8);
      expect(json['achieved_at'], '2026/05/24');
    });
  });

  group('UnitScore.toMap', () {
    test('正しく Map に変換できる', () {
      final unitScore = UnitScore(
        categoryNo: 3,
        unitNo: 9,
        score: 10,
        achievedAt: '2026/05/24',
      );

      final map = unitScore.toMap();

      expect(map['category_no'], 3);
      expect(map['unit_no'], 9);
      expect(map['score'], 10);
      expect(map['achieved_at'], '2026/05/24');
    });
  });

  group('UnitScore stars boundary', () {
    test('score=6 は ★3', () {
      final unitScore = UnitScore(
        categoryNo: 1,
        unitNo: 1,
        score: 6,
        achievedAt: '',
      );

      expect(unitScore.stars, 3);
    });

    test('score=7 は ★4', () {
      final unitScore = UnitScore(
        categoryNo: 1,
        unitNo: 1,
        score: 7,
        achievedAt: '',
      );

      expect(unitScore.stars, 4);
    });

    test('score=9 は ★4', () {
      final unitScore = UnitScore(
        categoryNo: 1,
        unitNo: 1,
        score: 9,
        achievedAt: '',
      );

      expect(unitScore.stars, 4);
    });

    test('score=10 は ★5', () {
      final unitScore = UnitScore(
        categoryNo: 1,
        unitNo: 1,
        score: 10,
        achievedAt: '',
      );

      expect(unitScore.stars, 5);
    });
  });

  group('UnitScore.fromJson invalid types', () {
    test('型が不正な場合は例外が発生する', () {
      final json = {
        'category_no': 'abc',
        'unit_no': 'def',
        'high_score': 'ghi',
        'achieved_at': 123,
      };

      expect(
        () => UnitScore.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('UnitScore serialization round trip', () {
    test('toJson → fromJson で値を維持できる', () {
      final original = UnitScore(
        categoryNo: 4,
        unitNo: 2,
        score: 9,
        achievedAt: '2026/05/24',
      );

      final json = original.toJson();
      final restored = UnitScore.fromJson(json);

      expect(restored.categoryNo, original.categoryNo);
      expect(restored.unitNo, original.unitNo);
      expect(restored.score, original.score);
      expect(restored.achievedAt, original.achievedAt);
      expect(restored.stars, original.stars);
      expect(restored.isPerfect, original.isPerfect);
    });
  });
}
