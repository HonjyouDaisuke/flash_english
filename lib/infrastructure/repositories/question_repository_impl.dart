import 'dart:convert';

import 'package:flash_english/domain/entities/question.dart';
import 'package:flash_english/domain/repositories/question_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/persistence/mappers/question_mapper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  ApiClient apiClient;
  QuestionRepositoryImpl(this.apiClient);

  @override
  Future<List<Question>> getQuestions(int categoryNo, int unitNo) async {
    final db = AppDatabase.instance.database;

    final result = await db.query('questions',
        where: 'category_no = ? AND unit_no = ?',
        whereArgs: [categoryNo, unitNo],
        orderBy: 'question_id');

    return result.map((map) => QuestionMapper.fromMap(map)).toList();
  }

  @override
  Future<List<Question>> getAllApi() async {
    final response = await apiClient.post(
      '/flash_english_backend/api/get-all-questions',
      body: {},
    );

    if (response.statusCode != 200) {
      debugPrint('Failed to fetch questions from API');
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      throw Exception('Failed to fetch questions from API');
    }
    debugPrint('Response body: ${response.body}');
    final decoded = jsonDecode(response.body);

    if (decoded == null) return [];

    final List data = decoded['questions'] as List;

    return data.map((e) => QuestionMapper.fromMap(e)).toList();
  }

  `@override`
  Future<void> insertAll(List<Question> questions) async {
    final db = AppDatabase.instance.database;
    await db.transaction((txn) async {
      await txn.delete('questions');
      final batch = txn.batch();
      for (final question in questions) {
        batch.insert(
          'questions',
          QuestionMapper.toMap(question),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }
  }
}
