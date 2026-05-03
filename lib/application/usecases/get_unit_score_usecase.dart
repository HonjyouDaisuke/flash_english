import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/domain/repositories/unit_score_repository.dart';

class GetUnitScoreUseCase {
  final UnitScoreRepository repository;

  GetUnitScoreUseCase(this.repository);

  Future<List<UnitScore>?> getAllAPI(int categoryNo) async {
    return await repository.getAllAPI(categoryNo);
  }
}
