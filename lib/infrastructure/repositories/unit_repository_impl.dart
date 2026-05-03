import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/domain/repositories/unit_repository.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/persistence/mappers/unit_mapper.dart';
import 'package:flutter/material.dart';

class UnitRepositoryImpl implements UnitRepository {
  @override
  Future<List<Unit>> getByCategory(
    int categoryId,
  ) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'units',
      where: 'category_no = ?',
      whereArgs: [categoryId],
      orderBy: 'unit_no',
    );
    return result
    return result
        .map(
          (map) => UnitMapper.fromMap(map),
        )
        .toList();
  }

  @override
  Future<String> getUnitDescription(int categoryId, int unitId) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'units',
      where: 'category_no = ? AND unit_no = ?',
      whereArgs: [categoryId, unitId],
    );
    final units = result.map((map) => UnitMapper.fromMap(map)).toList();
    if (units.isEmpty) {
      throw StateError(
        'Unit not found: categoryId=$categoryId, unitId=$unitId',
      );
    }
    return "${units[0].unitName} : ${units[0].unitDescription}";
  }
}
