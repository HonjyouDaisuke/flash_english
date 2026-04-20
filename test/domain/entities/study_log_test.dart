import 'package:flutter_test/flutter_test.dart';
import 'package:flash_english/domain/entities/study_log.dart';

void main() {
  group('StudyLog', () {
    test('全プロパティが正しく保持される', () {
      final createdAt = DateTime(2026, 4, 19, 20, 0, 0);

      final log = StudyLog(
        id: 1,
        categoryId: 10,
        unitId: 20,
        questionId: 30,
        isCorrect: true,
        sessionId: 99,
        durationSeconds: 12,
        createdAt: createdAt,
      );

      expect(log.id, 1);
      expect(log.categoryId, 10);
      expect(log.unitId, 20);
      expect(log.questionId, 30);
      expect(log.isCorrect, true);
      expect(log.sessionId, 99);
      expect(log.durationSeconds, 12);
      expect(log.createdAt, createdAt);
    });

    test('id が null でも生成できる', () {
      final createdAt = DateTime(2026, 4, 19);

      final log = StudyLog(
        categoryId: 1,
        unitId: 2,
        questionId: 3,
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
        categoryId: 1,
        unitId: 1,
        questionId: 7,
        isCorrect: false,
        sessionId: 2,
        durationSeconds: 15,
        createdAt: DateTime(2026, 4, 19, 21, 0),
      );

      expect(log.isCorrect, false);
      expect(log.durationSeconds, 15);
    });
  });
}
