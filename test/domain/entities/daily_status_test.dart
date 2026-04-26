import 'package:flutter_test/flutter_test.dart';
import 'package:flash_english/domain/entities/daily_stats.dart';

void main() {
  group('DailyStats', () {
    test('全プロパティが正しく保持される', () {
      final stats = DailyStats(
        studyTime: const Duration(hours: 1, minutes: 20),
        sentenceCount: 50,
        correctCount: 40,
        wrongCount: 10,
      );

      expect(stats.studyTime, const Duration(hours: 1, minutes: 20));
      expect(stats.sentenceCount, 50);
      expect(stats.correctCount, 40);
      expect(stats.wrongCount, 10);
    });

    test('値が 0 でも生成できる', () {
      final stats = DailyStats(
        studyTime: Duration.zero,
        sentenceCount: 0,
        correctCount: 0,
        wrongCount: 0,
      );

      expect(stats.studyTime, Duration.zero);
      expect(stats.sentenceCount, 0);
      expect(stats.correctCount, 0);
      expect(stats.wrongCount, 0);
    });

    test('不正解数が多いケースも保持できる', () {
      final stats = DailyStats(
        studyTime: const Duration(minutes: 30),
        sentenceCount: 20,
        correctCount: 5,
        wrongCount: 15,
      );

      expect(stats.correctCount, 5);
      expect(stats.wrongCount, 15);
      expect(stats.sentenceCount, 20);
    });
  });
}
