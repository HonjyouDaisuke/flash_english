import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/presentation/providers/auth_state.dart';

abstract class UnitScoreRepository {
  Future<List<UnitScore>> getAllScores();
  Future<void> saveScore(UnitScore score);
  Future<bool> saveAPI(UnitScore score);
  Future<List<UnitScore>> getAll(
    int categoryNo, {
    required AuthState authState,
  });
  Future<List<UnitScore>> getAllApi(String userId);
  Future<void> replaceLocal(List<UnitScore> scores);
}
