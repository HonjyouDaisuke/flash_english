import 'package:flutter_test/flutter_test.dart';
import 'package:flash_english/domain/entities/study_session.dart';

void main() {
  group('StudySession', () {
    test('endedAt がある場合、duration を正しく返す', () {
      final startedAt = DateTime(2026, 4, 19, 10, 0, 0);
      final endedAt = DateTime(2026, 4, 19, 11, 30, 0);

      final session = StudySession(
        id: 1,
        startedAt: startedAt,
        endedAt: endedAt,
      );

      expect(session.duration, const Duration(hours: 1, minutes: 30));
    });

    test('endedAt が null の場合、現在時刻との差分を返す', () {
      final startedAt = DateTime.now().subtract(
        const Duration(minutes: 10),
      );

      final session = StudySession(
        id: 2,
        startedAt: startedAt,
      );

      final duration = session.duration;

      expect(duration.inMinutes, 10);
    });

    test('id と startedAt が正しく保持される', () {
      final startedAt = DateTime(2026, 4, 19, 9, 0, 0);

      final session = StudySession(
        id: 99,
        startedAt: startedAt,
      );

      expect(session.id, 99);
      expect(session.startedAt, startedAt);
      expect(session.endedAt, isNull);
    });
  });
}
