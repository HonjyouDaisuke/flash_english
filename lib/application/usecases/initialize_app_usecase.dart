import 'package:flash_english/domain/repositories/seed_repository.dart';

class InitializeAppUseCase {
  final SeedRepository repository;

  InitializeAppUseCase(this.repository);

  Future<void> execute() async {
    final seeded = await repository.isSeeded();

    if (!seeded) {
      await repository.seed();
      await repository.setSeeded();
    }
  }
}
