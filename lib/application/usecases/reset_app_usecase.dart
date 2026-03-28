import 'package:flash_english/domain/repositories/seed_repository.dart';

class ResetAppUseCase {
  final SeedRepository repository;

  ResetAppUseCase(this.repository);

  Future<void> execute() async {
    await repository.reset();
  }
}
