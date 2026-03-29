import 'package:flash_english/domain/entities/study_log.dart';

abstract class StudyLogRepository {
  Future<List<StudyLog>> getAllLogs();
  Future<void> insertLog(StudyLog log);
}
