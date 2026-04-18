import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/domain/repositories/unit_score_repository.dart';

class SaveUnitScoreUseCase {
  final UnitScoreRepository repository;

  SaveUnitScoreUseCase(this.repository);

  Future<void> saveLocal(UnitScore score) async {
    return await repository.saveScore(score);
  }

  Future<bool> saveAPI(UnitScore score) async {
    return await repository.saveAPI(score);
  }
}
