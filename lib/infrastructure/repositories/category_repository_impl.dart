import 'dart:convert';

import 'package:flash_english/domain/entities/category.dart';
import 'package:flash_english/domain/repositories/category_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/persistence/mappers/category_mapper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiClient apiClient;
  CategoryRepositoryImpl(this.apiClient);

  @override
  Future<List<Category>> getAll() async {
    final db = AppDatabase.instance.database;

    final result = await db.query(
      'categories',
      orderBy: 'category_no',
    );

    debugPrint(
      result.toString(),
    );

    return result
        .map(
          (map) => CategoryMapper.fromMap(
            map,
          ),
        )
        .toList();
  }

  @override
  Future<List<Category>> getAllApi() async {
    final response = await apiClient.post(
      '/flash_english_backend/api/get-all-categories',
      body: {},
    );
    if (response.statusCode != 200) {
      debugPrint('Failed to fetch categories from API');
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      throw Exception('Failed to fetch categories from API');
    }
    final decoded = jsonDecode(response.body);
    if (decoded == null) return [];
    final List data = decoded['categories'] as List;
    return data.map((e) => CategoryMapper.fromMap(e)).toList();
  }

  `@override`
  Future<void> insertAll(List<Category> categories) async {
    final db = AppDatabase.instance.database;
    await db.transaction((txn) async {
      await txn.delete('categories');
      final batch = txn.batch();
      for (final category in categories) {
        batch.insert(
          'categories',
          CategoryMapper.toMap(category),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }
}
