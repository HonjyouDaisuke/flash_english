import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/repositories/question_repository.dart';
import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionLocalDataSource localDataSource;

  QuestionRepositoryImpl(this.localDataSource);

  @override
  Future<List<Question>> getQuestions() async {
    return await localDataSource.loadQuestions();
  }
}
