import 'package:flash_english/domain/entities/category.dart';
import 'package:flash_english/domain/repositories/category_repository.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/persistence/mappers/category_mapper.dart';
import 'package:flutter/material.dart';

class CategoryRepositoryImpl implements CategoryRepository {
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
}
