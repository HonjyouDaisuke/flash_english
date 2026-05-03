import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/repositories/question_repository.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/persistence/mappers/question_mapper.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  @override
  Future<List<Question>> getQuestions(int categoryId, int unitNo) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('questions',
        where: 'category_no = ? AND unit_no = ?',
        whereArgs: [categoryId, unitNo],
        orderBy: 'question_id');

    return result.map((map) => QuestionMapper.fromMap(map)).toList();
  }
}
