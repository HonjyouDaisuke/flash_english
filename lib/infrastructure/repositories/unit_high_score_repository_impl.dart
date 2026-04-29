import 'dart:convert';

import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/domain/repositories/unit_score_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/datasources/local/unit_score_local_data_source.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UnitScoreRepositoryImpl implements UnitScoreRepository {
  final UnitScoreLocalDataSource dataSource;
  final ApiClient _apiClient;
  final db = AppDatabase.instance;

  UnitScoreRepositoryImpl(this.dataSource, this._apiClient);

  @override
  Future<List<UnitScore>> getAllScores() async {
    final maps = await dataSource.getAllScores();

    return maps
        .map((m) => UnitScore(
              categoryId: (m['category_id'] ?? 0) as int,
              unitId: (m['unit_id'] ?? 0) as int,
              score: (m['score'] ?? 0) as int,
              achievedAt: m['achieved_at'] as String,
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
      debugPrint(
          "achieved_at = ${DateFormat('yyyy/MM/dd').format(DateTime.now())}");
      final response = await _apiClient.post(
        '/flash_english_backend/api/save-unit-high-scores',
        body: {
          'category_id': score.categoryId,
          'unit_id': score.unitId,
          'score': score.score,
          'achieved_at': DateFormat('yyyy/MM/dd').format(DateTime.now()),
        },
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint("Error saving unit score: status ${response.statusCode}");
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Error saving unit score: $e");
      return false;
    }
  }

  @override
  Future<List<UnitScore>?> getAllAPI(int categoryId) async {
    try {
      final response = await _apiClient.post(
        '/flash_english_backend/api/getall-unit-high-scores',
        body: {
          'category_id': categoryId,
        },
      );
      debugPrint("------------------------- categoryId = $categoryId");
      debugPrint(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint("Error get All unit score: status ${response.statusCode}");
        return null;
      }
      final decoded = jsonDecode(response.body);

      if (decoded == null) return [];

      final List data = decoded;

      return data.map((e) => UnitScore.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error get All unit score: $e");
      return null;
    }
  }
}
