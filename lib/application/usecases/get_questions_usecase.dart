import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/repositories/question_repository.dart';

class GetQuestionsUseCase {
  final QuestionRepository repository;

  GetQuestionsUseCase(this.repository);

  Future<List<Question>> execute() {
    return repository.getQuestions();
  }
}
