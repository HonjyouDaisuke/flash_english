import 'dart:convert';

import 'package:flash_english/domain/entities/study_log.dart';
import 'package:flash_english/domain/repositories/question_repository.dart';
import 'package:flash_english/domain/repositories/study_log_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/datasources/local/study_log_local_data_source.dart';
import 'package:flutter/material.dart';

class StudyLogRepositoryImpl implements StudyLogRepository {
  final StudyLogLocalDataSource dataSource;
  final QuestionRepository questionRepository;
  final ApiClient _apiClient;

  StudyLogRepositoryImpl(
      this.dataSource, this.questionRepository, this._apiClient);

  @override
  Future<List<StudyLog>> getAllLogs() async {
    final maps = await dataSource.getAllLogs();

    return maps
        .where((m) => m['question_id'] != null)
        .map((m) => StudyLog(
              id: m['id'] as String?,
              questionId: m['question_id'] as int,
              categoryNo: m['category_no'] as int,
              unitNo: m['unit_no'] as int,
              questionNo: m['question_no'] as int,
              isCorrect: (m['is_correct'] ?? 0) == 1,
              sessionId: (m['session_id'] ?? 0) as int,
              durationSeconds: (m['duration_seconds'] ?? 0) as int,
              createdAt: DateTime.parse(m['created_at'] as String),
            ))
        .toList();
  }

  @override
  Future<DateTime?> getLatestCreatedAt() {
    return dataSource.getLatestCreatedAt();
  }

  @override
  Future<List<StudyLog>> getByPeriod(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final maps = await dataSource.getByPeriod(startDate, endDate);

    return maps
        .where((m) => m['question_id'] != null)
        .map((m) => StudyLog(
              id: m['id'] as String?,
              questionId: m['question_id'] as int,
              categoryNo: m['category_no'] as int,
              unitNo: m['unit_no'] as int,
              questionNo: m['question_no'] as int,
              isCorrect: (m['is_correct'] ?? 0) == 1,
              sessionId: (m['session_id'] ?? 0) as int,
              durationSeconds: (m['duration_seconds'] ?? 0) as int,
              createdAt: DateTime.parse(m['created_at'] as String),
            ))
        .toList();
  }

  @override
  Future<void> insertLog(StudyLog log) async {
    final map = {
      'id': log.id,
      'question_id': log.questionId,
      'category_no': log.categoryNo,
      'unit_no': log.unitNo,
      'question_no': log.questionNo,
      'is_correct': log.isCorrect ? 1 : 0,
      'session_id': log.sessionId,
      'duration_seconds': log.durationSeconds,
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

  @override
  Future<List<StudyLog>> getAllApi(
    String userId,
    DateTime sinceDate,
  ) async {
    final response = await _apiClient.post(
      '/flash_english_backend/api/get-study-logs',
      body: {
        'user_id': userId,
        'since_date': sinceDate.toIso8601String(),
      },
    );

    debugPrint("★★Response status code: ${response.statusCode}");
    debugPrint(response.body);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final logs = decoded['logs'] as List;

    final result = <StudyLog>[];

    for (final item in logs) {
      final json = item as Map<String, dynamic>;

      final categoryNo = (json['category_no'] as num).toInt();
      final unitNo = (json['unit_no'] as num).toInt();
      final questionNo = (json['question_no'] as num).toInt();

      final questionId =
          await questionRepository.findQuestionIdByCategoryUnitQuestionNo(
        categoryNo: categoryNo,
        unitNo: unitNo,
        questionNo: questionNo,
      );

      if (questionId == null) {
        throw FormatException(
          'Question not found: '
          'category=$categoryNo, '
          'unit=$unitNo, '
          'question=$questionNo',
        );
      }

      result.add(
        StudyLog(
          id: json['id'] as String?,
          questionId: questionId,
          categoryNo: categoryNo,
          unitNo: unitNo,
          questionNo: questionNo,
          isCorrect: (json['is_correct'] as num).toInt() == 1,
          sessionId: (json['session_id'] as num).toInt(),
          durationSeconds: (json['duration_seconds'] as num).toInt(),
          createdAt: DateTime.parse(json['created_at'] as String),
        ),
      );
    }
    return result;
  }

  @override
  Future<void> upsertAll(List<StudyLog> logs) async {
    await dataSource.upsertAll(logs);
  }
}
