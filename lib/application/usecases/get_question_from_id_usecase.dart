import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/repositories/question_repository.dart';

class GetQuestionFromIdUseCase {
  final QuestionRepository repository;

  GetQuestionFromIdUseCase(this.repository);

  Future<Question> execute({required int questionId}) async {
    final question = await repository.getQuestion(questionId: questionId);
    if (question == null) {
      throw Exception('Question not found for questionId: $questionId');
    }
    return question;
  }

  Future<List<Question>> callApi() {
    return repository.getAllApi();
  }
}
