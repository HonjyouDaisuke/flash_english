import 'package:flash_english/domain/repositories/study_repository.dart';

class EndSessionUseCase {
  final StudyRepository repository;

  EndSessionUseCase(this.repository);

  Future<void> execute(int sessionId) {
    return repository.endSession(sessionId);
  }
}
