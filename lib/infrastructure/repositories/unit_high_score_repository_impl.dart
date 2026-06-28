import 'dart:convert';

import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/domain/repositories/unit_score_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/datasources/local/unit_score_local_data_source.dart';
import 'package:flash_english/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UnitScoreRepositoryImpl implements UnitScoreRepository {
  final UnitScoreLocalDataSource dataSource;
  final ApiClient _apiClient;
  final UnitScoreLocalDataSource local;

  UnitScoreRepositoryImpl(this.dataSource, this._apiClient, this.local);

  @override
  Future<List<UnitScore>> getAllScores() async {
    final maps = await dataSource.getAllScores();

    return maps
        .map((m) => UnitScore(
              categoryNo: (m['category_no'] ?? 0) as int,
              unitNo: (m['unit_no'] ?? 0) as int,
              score: (m['score'] ?? 0) as int,
              achievedAt: m['achieved_at'] as String,
            ))
        .toList();
  }

  @override
  Future<void> saveScore(UnitScore score) async {
    final map = {
      'category_no': score.categoryNo,
      'unit_no': score.unitNo,
      'score': score.score,
      'achieved_at': score.achievedAt,
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
          'category_no': score.categoryNo,
          'unit_no': score.unitNo,
          'score': score.score,
          'achieved_at': DateFormat('yyyy/MM/dd').format(DateTime.now()),
        },
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint("Error saving unit score: status ${response.statusCode}");
        throw Exception(
            "Error get All unit score: status ${response.statusCode}");
      }
      return true;
    } catch (e) {
      debugPrint("Error saving unit score: $e");
      throw Exception("Error saving unit score: $e");
    }
  }

  @override
  Future<List<UnitScore>> getAll(
    int categoryNo, {
    required AuthState authState,
  }) async {
    return local.getAll(categoryNo);
  }

  @override
  Future<List<UnitScore>> getAllApi(String userId) async {
    try {
      final response = await _apiClient.post(
        '/flash_english_backend/api/getall-unit-high-scores',
        body: {
          'user_id': userId,
        },
      );

      final decoded = jsonDecode(response.body) as List;
      return decoded.map((e) => UnitScore.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error get All unit score: $e");
      return [];
    }
  }

  @override
  Future<void> replaceLocal(List<UnitScore> scores) async {
    await local.upsertAll(scores);
    debugPrint("replaced localDB");
  }
}
