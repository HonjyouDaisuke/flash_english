import 'package:flash_english/domain/repositories/study_repository.dart';

class StartSessionUseCase {
  final StudyRepository repository;

  StartSessionUseCase(this.repository);

  Future<int> execute() {
    return repository.startSession();
  }
}
