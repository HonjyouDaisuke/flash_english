import 'package:flash_english/domain/repositories/unit_score_repository.dart';

class SyncUnitScoreUseCase {
  final UnitScoreRepository repository;

  SyncUnitScoreUseCase(this.repository);

  Future<void> execute(String userId) async {
    final scores = await repository.getAllApi(userId);
    await repository.replaceLocal(scores);
  }
}
