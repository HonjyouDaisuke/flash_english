import 'package:flash_english/presentation/controllers/questions_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestionsController', () {
    test('start() initializes questions', () {
      final controller = QuestionsContoller(false);

      final id = controller.start();

      expect(id, 1);
      expect(controller.currentPos, 0);
      expect(controller.isStarted, true);
      expect(controller.questionsOrder, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    });

    test('next() moves to next question', () {
      final controller = QuestionsContoller(false);

      controller.start();

      expect(controller.next(), 2);
      expect(controller.currentPos, 1);

      expect(controller.next(), 3);
      expect(controller.currentPos, 2);
    });

    test('answer() marks current question as answered', () {
      final controller = QuestionsContoller(false);

      controller.start();

      final next = controller.answer();

      expect(next, 2);
      expect(controller.questionsOrder[0], -1);
      expect(controller.currentPos, 1);
    });

    test('answered questions are skipped', () {
      final controller = QuestionsContoller(false);

      controller.start();

      controller.answer(); // 1 answered
      controller.answer(); // 2 answered

      expect(controller.currentPos, 2);
      expect(controller.questionsOrder[0], -1);
      expect(controller.questionsOrder[1], -2);

      expect(controller.next(), 4);
      expect(controller.currentPos, 3);
    });

    test('prev() goes back one position', () {
      final controller = QuestionsContoller(false);

      controller.start();
      controller.next();
      controller.next();

      expect(controller.currentPos, 2);

      expect(controller.prev(), 2);
      expect(controller.currentPos, 1);
    });

    test('all questions answered returns 99', () {
      final controller = QuestionsContoller(false);

      controller.start();

      for (int i = 0; i < 10; i++) {
        controller.answer();
      }

      expect(controller.next(), 99);
    });

    test('random mode contains 1-10 without duplicates', () {
      final controller = QuestionsContoller(true);

      controller.start();

      final sorted = [...controller.questionsOrder]..sort();

      expect(sorted, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    });
  });
}
