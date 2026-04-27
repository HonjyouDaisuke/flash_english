import 'package:flash_english/domain/entities/study_log.dart';
import 'package:flash_english/domain/repositories/study_log_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/datasources/local/study_log_local_data_source.dart';
import 'package:flutter/material.dart';

class StudyLogRepositoryImpl implements StudyLogRepository {
  final StudyLogLocalDataSource dataSource;
  final ApiClient _apiClient;

  StudyLogRepositoryImpl(this.dataSource, this._apiClient);

  @override
  Future<List<StudyLog>> getAllLogs() async {
    final maps = await dataSource.getAllLogs();

    return maps
        .map((m) => StudyLog(
              id: m['id'] as int?,
              categoryId: (m['category_id'] ?? 0) as int,
              unitId: (m['unit_id'] ?? 0) as int,
              questionId: (m['question_id'] ?? 0) as int,
              isCorrect: (m['is_correct'] ?? 0) == 1,
              sessionId: (m['session_id'] ?? 0) as int,
              durationSeconds: (m['duration'] ?? 0) as int,
              createdAt: DateTime.parse(m['created_at'] as String),
            ))
        .toList();
  }

  @override
  Future<void> insertLog(StudyLog log) async {
    final map = {
      'category_id': log.categoryId,
      'unit_id': log.unitId,
      'question_id': log.questionId,
      'is_correct': log.isCorrect ? 1 : 0,
      'session_id': log.sessionId,
      'duration': log.durationSeconds,
      'created_at': log.createdAt.toIso8601String(),
    };

    await dataSource.insertLog(map);
  }

  @override
  Future<bool> save(StudyLog log) async {
    try {
      await _apiClient.post(
        '/flash_english_backend/api/study-log',
        body: {
          'category_id': log.categoryId,
          'unit_id': log.unitId,
          'question_id': log.questionId,
          'is_correct': log.isCorrect ? 1 : 0,
          'session_id': log.sessionId,
          'duration_seconds': log.durationSeconds,
        },
      );
      return true;
    } catch (e) {
      debugPrint("Error saving study log: $e");
      return false;
    }
  }
}
