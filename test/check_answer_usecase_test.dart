import 'package:flutter_test/flutter_test.dart';
import 'package:flash_english/application/usecases/check_answer_usecase.dart';
import 'package:flash_english/domain/entities/question.dart';

void main() {
  final useCase = CheckAnswerUseCase();

  final question = Question(
    id: 1,
    category: 'カテゴリ',
    japanese: "私はコーヒーが好きです",
    english: "I like coffee",
    japaneseAudio: "",
    englishAudio: "",
  );

  group('CheckAnswerUseCase', () {
    test('完全一致で正解になる', () {
      final result = useCase.execute(question, "I like coffee");
      expect(result, true);
    });

    test('大文字小文字違いでも正解になる', () {
      final result = useCase.execute(question, "i like coffee");
      expect(result, true);
    });

    test('ピリオドありでも正解になる', () {
      final result = useCase.execute(question, "i like coffee.");
      expect(result, true);
    });

    test('間違った回答は不正解になる', () {
      final result = useCase.execute(question, "I play coffee");
      expect(result, false);
    });
  });
}
