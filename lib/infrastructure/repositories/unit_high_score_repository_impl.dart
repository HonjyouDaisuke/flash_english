import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/domain/repositories/unit_score_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/datasources/local/unit_score_local_data_source.dart';
import 'package:flutter/material.dart';

class UnitScoreRepositoryImpl implements UnitScoreRepository {
  final UnitScoreLocalDataSource dataSource;
  final ApiClient _apiClient;

  UnitScoreRepositoryImpl(this.dataSource, this._apiClient);

  @override
  Future<List<UnitScore>> getAllScores() async {
    final maps = await dataSource.getAllScores();

    return maps
        .map((m) => UnitScore(
              categoryId: (m['category_id'] ?? 0) as int,
              unitId: (m['unit_id'] ?? 0) as int,
              score: (m['score'] ?? 0) as int,
            ))
        .toList();
  }

  @override
  Future<void> saveScore(UnitScore score) async {
    final map = {
      'category_id': score.categoryId,
      'unit_id': score.unitId,
      'score': score.score,
    };

    await dataSource.saveScore(map);
  }

  @override
  Future<bool> saveAPI(UnitScore score) async {
    try {
      await _apiClient.post(
        'http://10.0.2.2:8888/flash_english_backend/api/unit-high-scores',
        body: {
          'category_id': score.categoryId,
          'unit_id': score.unitId,
          'score': score.score,
        },
      );
      return true;
    } catch (e) {
      debugPrint("Error saving study log: $e");
      return false;
    }
  }
}
