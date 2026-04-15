import 'package:flash_english/domain/entities/study_log.dart';
import 'package:flash_english/domain/repositories/study_log_repository.dart';

class SaveStudyLogUseCase {
  final StudyLogRepository repository;

  SaveStudyLogUseCase(this.repository);

  Future<bool> execute(StudyLog log) async {
    final studyLog = StudyLog(
      categoryId: log.categoryId,
      unitId: log.unitId,
      questionId: log.questionId,
      isCorrect: log.isCorrect,
      sessionId: log.sessionId,
      durationSeconds: log.durationSeconds,
      createdAt: log.createdAt,
    );
    return await repository.save(studyLog);
  }
}
