import 'package:flutter_test/flutter_test.dart';
import 'package:flash_english/domain/entities/study_log.dart';

void main() {
  group('StudyLog', () {
    test('全プロパティが正しく保持される', () {
      final createdAt = DateTime(2026, 4, 19, 20, 0, 0);

      final log = StudyLog(
        id: "aaa-bbb-ccc",
        questionId: 30,
        categoryNo: 2,
        unitNo: 3,
        questionNo: 4,
        isCorrect: true,
        sessionId: 99,
        durationSeconds: 12,
        createdAt: createdAt,
      );

      expect(log.id, "aaa-bbb-ccc");
      expect(log.questionId, 30);
      expect(log.isCorrect, true);
      expect(log.sessionId, 99);
      expect(log.durationSeconds, 12);
      expect(log.createdAt, createdAt);
    });

    test('id が null でも生成できる', () {
      final createdAt = DateTime(2026, 4, 19);

      final log = StudyLog(
        id: null,
        questionId: 3,
        categoryNo: 1,
        unitNo: 2,
        questionNo: 5,
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
        id: "ddd-eee-fff",
        questionId: 10,
        categoryNo: 1,
        unitNo: 2,
        questionNo: 3,
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
        id: "aaa-bbb-ccc",
        questionId: 30,
        categoryNo: 2,
        unitNo: 3,
        questionNo: 4,
        isCorrect: true,
        sessionId: 99,
        durationSeconds: 12,
        createdAt: createdAt,
      );

      final json = log.toJson();

      expect(json['id'], "aaa-bbb-ccc");
      expect(json['question_id'], 30);
      expect(json['is_correct'], true);
      expect(json['session_id'], 99);
      expect(json['duration'], 12);
      expect(
        json['created_at'],
        createdAt.toUtc().toIso8601String(),
      );
    });

    test('id が null の場合も JSON 変換できる', () {
      final log = StudyLog(
        id: null,
        questionId: 3,
        categoryNo: 1,
        unitNo: 2,
        questionNo: 5,
        isCorrect: false,
        sessionId: 4,
        durationSeconds: 5,
        createdAt: DateTime.utc(2026, 4, 19),
      );

      final json = log.toJson();

      expect(json['id'], isNull);
      expect(json['question_id'], 3);
      expect(json['is_correct'], false);
      expect(json['session_id'], 4);
      expect(json['duration'], 5);
    });

    test('created_at は UTC ISO8601 形式で出力される', () {
      final localTime = DateTime(2026, 4, 19, 21, 15, 30);

      final log = StudyLog(
        id: "aaa-bbb-ccc",
        questionId: 1,
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
        id: "zzz-yyy-xxx",
        questionId: 1,
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

      expect(json['duration'], 0);
    });
  });
  group('StudyLog.fromJson', () {
    test('JSONから正しく生成できる', () {
      final json = {
        'id': 'aaa-bbb',
        'question_id': 30,
        'category_no': 2,
        'unit_no': 3,
        'question_no': 4,
        'is_correct': 1,
        'session_id': 99,
        'duration': 12,
        'created_at': '2026-04-19T12:30:45Z',
      };

      final log = StudyLog.fromJson(json);

      expect(log.id, 'aaa-bbb');
      expect(log.questionId, 30);
      expect(log.categoryNo, 2);
      expect(log.unitNo, 3);
      expect(log.questionNo, 4);
      expect(log.isCorrect, isTrue);
      expect(log.sessionId, 99);
      expect(log.durationSeconds, 12);
      expect(log.createdAt, DateTime.parse('2026-04-19T12:30:45Z'));
    });
  });

  test('nullの値はデフォルト値になる', () {
    final json = {
      'created_at': '2026-04-19T12:30:45Z',
    };

    final log = StudyLog.fromJson(json);

    expect(log.id, isNull);
    expect(log.questionId, 0);
    expect(log.categoryNo, 0);
    expect(log.unitNo, 0);
    expect(log.questionNo, 0);
    expect(log.isCorrect, isFalse);
    expect(log.sessionId, 0);
    expect(log.durationSeconds, 0);
  });

  test('is_correct が0ならfalseになる', () {
    final json = {
      'question_id': 1,
      'category_no': 1,
      'unit_no': 1,
      'question_no': 1,
      'is_correct': 0,
      'session_id': 1,
      'duration': 3,
      'created_at': '2026-04-19T12:30:45Z',
    };

    final log = StudyLog.fromJson(json);

    expect(log.isCorrect, isFalse);
  });

  group('StudyLog.toMap', () {
    test('DB用Mapへ変換できる', () {
      final createdAt = DateTime.utc(2026, 4, 19);

      final log = StudyLog(
        id: 'aaa',
        questionId: 10,
        categoryNo: 1,
        unitNo: 2,
        questionNo: 3,
        isCorrect: true,
        sessionId: 5,
        durationSeconds: 8,
        createdAt: createdAt,
      );

      final map = log.toMap();

      expect(map['id'], 'aaa');
      expect(map['question_id'], 10);
      expect(map['category_no'], 1);
      expect(map['unit_no'], 2);
      expect(map['question_no'], 3);
      expect(map['is_correct'], 1);
      expect(map['session_id'], 5);
      expect(map['duration'], 8);
      expect(
        map['created_at'],
        createdAt.toUtc().toIso8601String(),
      );
    });
  });

  test('isCorrect=falseは0になる', () {
    final log = StudyLog(
      id: null,
      questionId: 1,
      categoryNo: 1,
      unitNo: 1,
      questionNo: 1,
      isCorrect: false,
      sessionId: 1,
      durationSeconds: 1,
      createdAt: DateTime.utc(2026),
    );

    expect(log.toMap()['is_correct'], 0);
  });
}
