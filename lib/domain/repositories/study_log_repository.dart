import 'package:flash_english/domain/entities/study_log.dart';

abstract class StudyLogRepository {
  Future<List<StudyLog>> getAllLogs();
  Future<List<StudyLog>> getByPeriod(DateTime startDate, DateTime endDate);
  Future<void> insertLog(StudyLog log);
  Future<bool> save(StudyLog log);
  Future<DateTime?> getLatestCreatedAt();
  Future<List<StudyLog>> getAllApi(String userId, DateTime sinceDate);
  Future<void> upsertAll(List<StudyLog> logs);
}
