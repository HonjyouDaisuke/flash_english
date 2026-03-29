import 'package:flash_english/domain/entities/study_log.dart';
import 'package:flash_english/domain/repositories/study_log_repository.dart';
import 'package:flash_english/infrastructure/datasources/local/study_log_local_data_source.dart';

class StudyLogRepositoryImpl implements StudyLogRepository {
  final StudyLogLocalDataSource dataSource;

  StudyLogRepositoryImpl(this.dataSource);

  @override
  Future<List<StudyLog>> getAllLogs() async {
    final maps = await dataSource.getAllLogs();

    return maps
        .map((m) => StudyLog(
              questionId: (m['question_id'] ?? 0) as int,
              isCorrect: (m['is_correct'] ?? 0) == 1,
              createdAt: DateTime.parse(m['created_at'] as String),
              sessionId: (m['session_id'] ?? 0) as int,
              durationSeconds: (m['duration'] ?? 0) as int,
            ))
        .toList();
  }

  @override
  Future<void> insertLog(StudyLog log) async {
    final map = {
      'question_id': log.questionId,
      'is_correct': log.isCorrect ? 1 : 0,
      'created_at': log.createdAt.toIso8601String(),
      'session_id': log.sessionId,
      'duration': log.durationSeconds,
    };

    await dataSource.insertLog(map);
  }
}
