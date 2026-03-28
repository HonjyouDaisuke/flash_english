import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/repositories/question_repository.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/persistence/mappers/question_mapper.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  @override
  Future<List<Question>> getQuestions() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('questions');

    return result.map((map) => QuestionMapper.fromMap(map)).toList();
  }
}
