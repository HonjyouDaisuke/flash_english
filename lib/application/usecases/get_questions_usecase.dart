import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/repositories/question_repository.dart';

class GetQuestionsUseCase {
  final QuestionRepository repository;

  GetQuestionsUseCase(this.repository);

  Future<List<Question>> execute(int categoryNo, int unitNo) {
    return repository.getQuestions(categoryNo, unitNo);
  }

  Future<List<Question>> callApi() {
    return repository.getAllApi();
  }
}
