import 'package:flutter_test/flutter_test.dart';
import 'package:flash_english/domain/entities/question_stats.dart';

void main() {
  group('QuestionStats', () {
    test('fromJsonで正しく生成できる', () {
      final json = {
        'question_id': 123,
        'category_no': 1,
        'unit_no': 2,
        'question_no': 3,
        'correct_count': 8,
        'wrong_count': 2,
        'created_at': '2026-08-16T10:30:00Z',
      };

      final stats = QuestionStats.fromJson(json);

      expect(stats.questionId, 123);
      expect(stats.categoryNo, 1);
      expect(stats.unitNo, 2);
      expect(stats.questionNo, 3);
      expect(stats.correctCount, 8);
      expect(stats.wrongCount, 2);
      expect(
        stats.createdAt,
        DateTime.parse('2026-08-16T10:30:00Z'),
      );
    });

    test('fromJsonでnum型の値をintに変換できる', () {
      final json = {
        'question_id': 123.0,
        'category_no': 1.0,
        'unit_no': 2.0,
        'question_no': 3.0,
        'correct_count': 8.0,
        'wrong_count': 2.0,
        'created_at': '2026-08-16T10:30:00Z',
      };

      final stats = QuestionStats.fromJson(json);

      expect(stats.questionId, 123);
      expect(stats.categoryNo, 1);
      expect(stats.unitNo, 2);
      expect(stats.questionNo, 3);
      expect(stats.correctCount, 8);
      expect(stats.wrongCount, 2);
    });

    test('created_atがnullの場合は現在時刻が設定される', () {
      final before = DateTime.now();

      final json = {
        'question_id': 123,
        'category_no': 1,
        'unit_no': 2,
        'question_no': 3,
        'correct_count': 8,
        'wrong_count': 2,
        'created_at': null,
      };

      final stats = QuestionStats.fromJson(json);

      final after = DateTime.now();

      expect(
        stats.createdAt.isAfter(
          before.subtract(const Duration(seconds: 1)),
        ),
        isTrue,
      );
      expect(
        stats.createdAt.isBefore(
          after.add(const Duration(seconds: 1)),
        ),
        isTrue,
      );
    });

    test('toMapで正しいMapに変換できる', () {
      final createdAt = DateTime.parse('2026-08-16T10:30:00Z');

      final stats = QuestionStats(
        questionId: 123,
        categoryNo: 1,
        unitNo: 2,
        questionNo: 3,
        correctCount: 8,
        wrongCount: 2,
        createdAt: createdAt,
      );

      final map = stats.toMap();

      expect(map['question_id'], 123);
      expect(map['category_no'], 1);
      expect(map['unit_no'], 2);
      expect(map['question_no'], 3);
      expect(map['correct_count'], 8);
      expect(map['wrong_count'], 2);
      expect(map['created_at'], createdAt.toUtc().toIso8601String());
    });

    test('toMapのcreated_atはUTCのISO8601形式になる', () {
      final createdAt = DateTime(
        2026,
        8,
        16,
        19,
        30,
      );

      final stats = QuestionStats(
        questionId: 123,
        categoryNo: 1,
        unitNo: 2,
        questionNo: 3,
        correctCount: 8,
        wrongCount: 2,
        createdAt: createdAt,
      );

      final map = stats.toMap();

      expect(
        map['created_at'],
        createdAt.toUtc().toIso8601String(),
      );

      expect(map['created_at'], endsWith('Z'));
    });

    test('fromJsonとtoMapを往復しても値が保持される', () {
      final json = {
        'question_id': 123,
        'category_no': 1,
        'unit_no': 2,
        'question_no': 3,
        'correct_count': 8,
        'wrong_count': 2,
        'created_at': '2026-08-16T10:30:00Z',
      };

      final stats = QuestionStats.fromJson(json);
      final map = stats.toMap();

      expect(map['question_id'], json['question_id']);
      expect(map['category_no'], json['category_no']);
      expect(map['unit_no'], json['unit_no']);
      expect(map['question_no'], json['question_no']);
      expect(map['correct_count'], json['correct_count']);
      expect(map['wrong_count'], json['wrong_count']);

      expect(
        map['created_at'],
        stats.createdAt.toUtc().toIso8601String(),
      );
    });
  });
}
