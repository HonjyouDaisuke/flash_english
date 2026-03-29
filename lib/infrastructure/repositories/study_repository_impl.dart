import 'package:flash_english/domain/repositories/study_repository.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';

class StudyRepositoryImpl implements StudyRepository {
  final db = AppDatabase.instance;

  @override
  Future<int> startSession() async {
    final database = await db.database;

    return await database.insert('study_sessions', {
      'startedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> endSession(int sessionId) async {
    final database = await db.database;

    await database.update(
      'study_sessions',
      {'endedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  @override
  Future<void> saveAnswer({
    required int questionId,
    required bool isCorrect,
    required int sessionId,
  }) async {
    final database = await db.database;

    await database.insert('study_logs', {
      'questionId': questionId,
      'isCorrect': isCorrect ? 1 : 0,
      'createdAt': DateTime.now().toIso8601String(),
      'sessionId': sessionId,
    });
  }
}
