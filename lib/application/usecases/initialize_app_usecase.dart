import 'package:flash_english/domain/repositories/seed_repository.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';

class InitializeAppUseCase {
  final SeedRepository repository;

  InitializeAppUseCase(this.repository);

  Future<void> execute() async {
    final db = await AppDatabase.instance.database;

    await db.transaction((txn) async {
      final seeded = await repository.isSeeded(txn);

      if (!seeded) {
        await repository.seed(txn);
        await repository.setSeeded(txn);
      }
    });
  }
}
