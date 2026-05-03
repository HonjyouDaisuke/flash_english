import 'package:flash_english/domain/entities/question.dart';

abstract class QuestionRepository {
  Future<List<Question>> getQuestions(int categoryNo, int unitNo);
}
