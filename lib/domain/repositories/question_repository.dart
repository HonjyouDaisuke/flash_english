import 'package:flash_english/domain/entities/question.dart';

abstract class QuestionRepository {
  Future<List<Question>> getQuestions(int categoryNo, int unitNo);
  Future<List<Question>> getAllApi();
  Future<void> insertAll(List<Question> questions);
}
