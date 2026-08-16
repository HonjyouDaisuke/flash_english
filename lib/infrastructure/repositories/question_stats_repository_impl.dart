import 'dart:convert';

import 'package:flash_english/domain/entities/question_stats.dart';
import 'package:flash_english/domain/repositories/question_stats_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/datasources/local/question_status_local_data_source.dart';
import 'package:flutter/material.dart';

class QuestionStatsRepositoryImpl implements QuestionStatsRepository {
  final QuestionStatsLocalDataSource dataSource;
  final ApiClient _apiClient;

  QuestionStatsRepositoryImpl(this.dataSource, this._apiClient);

  @override
  Future<List<QuestionStats>> getAllQuestionStats() async {
    return dataSource.getAll();
  }

  @override
  Future<void> insertQuestionStats(Map<String, dynamic> map) async {
    await dataSource.insertQuestionStats(map);
  }

  @override
  Future<void> upsertAll(List<QuestionStats> stats) async {
    for (final stat in stats) {
      await dataSource.insertQuestionStats(stat.toMap());
    }
  }

  @override
  Future<List<QuestionStats>> getAllApi(
    String userId,
  ) async {
    final response = await _apiClient.post(
      '/flash_english_backend/api/get-question-stats',
      body: {
        'user_id': userId,
      },
    );

    debugPrint("★★Response Question Stats: ${response.statusCode}");
    debugPrint(response.body);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final logs = decoded['stats'] as List;

    final result = <QuestionStats>[];

    for (final item in logs) {
      final json = item as Map<String, dynamic>;

      final categoryNo = (json['category_no'] as num).toInt();
      final unitNo = (json['unit_no'] as num).toInt();
      final questionNo = (json['question_no'] as num).toInt();
      final questionId = (json['question_id'] as num).toInt();
      final correctCount = (json['correct_count'] as num).toInt();
      final wrongCount = (json['wrong_count'] as num).toInt();
      final createdAt = json['created_at'] != null
          ? DateTime.parse('${json['created_at'] as String}Z')
          : DateTime.now();

      result.add(
        QuestionStats(
          questionId: questionId,
          categoryNo: categoryNo,
          unitNo: unitNo,
          questionNo: questionNo,
          correctCount: correctCount,
          wrongCount: wrongCount,
          createdAt: createdAt,
        ),
      );
    }
    return result;
  }
}
