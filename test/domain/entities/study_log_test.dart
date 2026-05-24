import 'package:flutter_test/flutter_test.dart';
import 'package:flash_english/domain/entities/study_log.dart';

void main() {
  group('StudyLog', () {
    test('全プロパティが正しく保持される', () {
      final createdAt = DateTime(2026, 4, 19, 20, 0, 0);

      final log = StudyLog(
        id: 1,
        categoryNo: 10,
        unitNo: 20,
        questionNo: 30,
        isCorrect: true,
        sessionId: 99,
        durationSeconds: 12,
        createdAt: createdAt,
      );

      expect(log.id, 1);
      expect(log.categoryNo, 10);
      expect(log.unitNo, 20);
      expect(log.questionNo, 30);
      expect(log.isCorrect, true);
      expect(log.sessionId, 99);
      expect(log.durationSeconds, 12);
      expect(log.createdAt, createdAt);
    });

    test('id が null でも生成できる', () {
      final createdAt = DateTime(2026, 4, 19);

      final log = StudyLog(
        categoryNo: 1,
        unitNo: 2,
        questionNo: 3,
        isCorrect: false,
        sessionId: 4,
        durationSeconds: 8,
        createdAt: createdAt,
      );

      expect(log.id, isNull);
      expect(log.isCorrect, false);
    });

    test('誤答ログも正しく保持される', () {
      final log = StudyLog(
        id: 5,
        categoryNo: 1,
        unitNo: 1,
        questionNo: 7,
        isCorrect: false,
        sessionId: 2,
        durationSeconds: 15,
        createdAt: DateTime(2026, 4, 19, 21, 0),
      );

      expect(log.isCorrect, false);
      expect(log.durationSeconds, 15);
    });
  });

  group('StudyLog.toJson', () {
    test('正しく JSON に変換できる', () {
      final createdAt = DateTime.utc(2026, 4, 19, 12, 30, 45);

      final log = StudyLog(
        id: 1,
        categoryNo: 10,
        unitNo: 20,
        questionNo: 30,
        isCorrect: true,
        sessionId: 99,
        durationSeconds: 12,
        createdAt: createdAt,
      );

      final json = log.toJson();

      expect(json['id'], 1);
      expect(json['category_no'], 10);
      expect(json['unit_no'], 20);
      expect(json['question_no'], 30);
      expect(json['is_correct'], true);
      expect(json['session_id'], 99);
      expect(json['duration_seconds'], 12);
      expect(
        json['created_at'],
        createdAt.toUtc().toIso8601String(),
      );
    });

    test('id が null の場合も JSON 変換できる', () {
      final log = StudyLog(
        categoryNo: 1,
        unitNo: 2,
        questionNo: 3,
        isCorrect: false,
        sessionId: 4,
        durationSeconds: 5,
        createdAt: DateTime.utc(2026, 4, 19),
      );

      final json = log.toJson();

      expect(json['id'], isNull);
      expect(json['category_no'], 1);
      expect(json['unit_no'], 2);
      expect(json['question_no'], 3);
      expect(json['is_correct'], false);
      expect(json['session_id'], 4);
      expect(json['duration_seconds'], 5);
    });

    test('created_at は UTC ISO8601 形式で出力される', () {
      final localTime = DateTime(2026, 4, 19, 21, 15, 30);

      final log = StudyLog(
        categoryNo: 1,
        unitNo: 1,
        questionNo: 1,
        isCorrect: true,
        sessionId: 1,
        durationSeconds: 1,
        createdAt: localTime,
      );

      final json = log.toJson();

      expect(
        json['created_at'],
        localTime.toUtc().toIso8601String(),
      );
    });

    test('durationSeconds が 0 でも保持できる', () {
      final log = StudyLog(
        categoryNo: 1,
        unitNo: 1,
        questionNo: 1,
        isCorrect: true,
        sessionId: 1,
        durationSeconds: 0,
        createdAt: DateTime.utc(2026, 4, 19),
      );

      expect(log.durationSeconds, 0);

      final json = log.toJson();

      expect(json['duration_seconds'], 0);
    });
  });
}
