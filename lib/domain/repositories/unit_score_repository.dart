import 'package:flash_english/domain/entities/unit_score.dart';

abstract class UnitScoreRepository {
  Future<List<UnitScore>> getAllScores();
  Future<void> saveScore(UnitScore score);
  Future<bool> saveAPI(UnitScore score);
}
