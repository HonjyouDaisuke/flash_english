import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';
import 'package:flash_english/infrastructure/persistence/mappers/question_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flash_english/domain/repositories/seed_repository.dart';
import 'app_database.dart';
import 'package:flash_english/domain/entities/question.dart';

class SeedRepositoryImpl implements SeedRepository {
  static const _seedKey = 'is_seeded';

  final QuestionLocalDataSource dataSource;

  SeedRepositoryImpl(this.dataSource);

  @override
  Future<bool> isSeeded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seedKey) ?? false;
  }

  @override
  Future<void> setSeeded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seedKey, true);
  }

  @override
  Future<void> seed() async {
    final db = await AppDatabase.instance.database;

    // 🔥 JSONから読み込み
    final List<Question> questions = await dataSource.loadQuestions();

    await db.transaction((txn) async {
      for (final q in questions) {
        await txn.insert('questions', QuestionMapper.toMap(q));
      }
    });
  }

  @override
  Future<void> reset() async {
    final db = await AppDatabase.instance.database;

    await db.delete('questions');
    await seed();
    await setSeeded();
  }
}
