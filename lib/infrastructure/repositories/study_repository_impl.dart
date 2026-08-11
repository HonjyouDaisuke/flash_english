import 'package:flash_english/domain/repositories/study_repository.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';

class StudyRepositoryImpl implements StudyRepository {
  final db = AppDatabase.instance;

  @override
  Future<int> startSession() async {
    final database = db.database;

    return await database.insert('study_sessions', {
      'started_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> endSession(int sessionId) async {
    final database = db.database;

    await database.update(
      'study_sessions',
      {'ended_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  @override
  Future<void> saveAnswer({
    required String id,
    required int questionId,
    required bool isCorrect,
    required int sessionId,
    required int categoryNo,
    required int unitNo,
    required int questionNo,
    required int durationSeconds,
  }) async {
    final database = db.database;

    await database.insert('study_logs', {
      'id': id,
      'question_id': questionId,
      'is_correct': isCorrect ? 1 : 0,
      'created_at': DateTime.now().toIso8601String(),
      'session_id': sessionId,
      'category_no': categoryNo,
      'unit_no': unitNo,
      'question_no': questionNo,
      'duration': durationSeconds,
    });
  }
}
