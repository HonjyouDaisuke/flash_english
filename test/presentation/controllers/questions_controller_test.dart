import 'package:flash_english/presentation/controllers/questions_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestionsController', () {
    test('start() initializes questions', () {
      final controller = QuestionsController();

      final id = controller.start(isRandom: false);

      expect(id, 1);
      expect(controller.currentPos, 0);
      expect(controller.isStarted, true);
      expect(controller.questionsOrder, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    });

    test('next() moves to next question', () {
      final controller = QuestionsController();

      controller.start(isRandom: false);

      expect(controller.next(), 2);
      expect(controller.currentPos, 1);

      expect(controller.next(), 3);
      expect(controller.currentPos, 2);
    });

    test('answer() marks current question as answered', () {
      final controller = QuestionsController();

      controller.start(isRandom: false);

      final next = controller.markAnswered();

      expect(next, 2);
      expect(controller.questionsOrder[0], -1);
      expect(controller.currentPos, 1);
    });

    test('answered questions are skipped', () {
      final controller = QuestionsController();

      controller.start(isRandom: false);

      controller.markAnswered(); // 1 answered
      controller.markAnswered(); // 2 answered

      expect(controller.currentPos, 2);
      expect(controller.questionsOrder[0], -1);
      expect(controller.questionsOrder[1], -2);

      expect(controller.next(), 4);
      expect(controller.currentPos, 3);
    });

    test('prev() goes back one position', () {
      final controller = QuestionsController();

      controller.start(isRandom: false);
      controller.next();
      controller.next();

      expect(controller.currentPos, 2);

      expect(controller.prev(), 2);
      expect(controller.currentPos, 1);
    });

    test('all questions answered returns null', () {
      final controller = QuestionsController();

      controller.start(isRandom: false);

      for (int i = 0; i < 10; i++) {
        controller.markAnswered();
      }

      expect(controller.next(), null);
    });

    test('random mode contains 1-10 without duplicates', () {
      final controller = QuestionsController();

      controller.start(isRandom: true);

      final sorted = [...controller.questionsOrder]..sort();

      expect(sorted, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    });
  });
}
