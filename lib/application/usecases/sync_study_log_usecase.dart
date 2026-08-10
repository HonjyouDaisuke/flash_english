import 'package:flash_english/domain/repositories/study_log_repository.dart';

class SyncStudyLogUseCase {
  final StudyLogRepository repository;

  SyncStudyLogUseCase(this.repository);

  Future<void> execute(String userId, DateTime latest) async {
    final logs = await repository.getAllApi(
      userId,
      latest,
    );
    await repository.upsertAll(logs);
  }
}
