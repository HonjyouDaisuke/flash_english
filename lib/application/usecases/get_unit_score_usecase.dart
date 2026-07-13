import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/domain/repositories/unit_score_repository.dart';
import 'package:flash_english/presentation/providers/auth/auth_state.dart';

class GetUnitScoreUseCase {
  final UnitScoreRepository repository;

  const GetUnitScoreUseCase(this.repository);

  Future<List<UnitScore>> getAll(int categoryNo, AuthState authState) async {
    return repository.getAll(categoryNo, authState: authState);
  }
}
