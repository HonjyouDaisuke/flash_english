import 'dart:convert';

import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/domain/repositories/unit_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/persistence/mappers/unit_mapper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class UnitRepositoryImpl implements UnitRepository {
  final ApiClient apiClient;
  UnitRepositoryImpl(this.apiClient);

  // TODO; 今は偶数のユニットだけを返すようにしているが、オーディオファイルをダウンロードしているかどうかをチェックする
  List<Unit> checkUnitsAudio(List<Unit> units) {
    final resultUnits = <Unit>[];

    for (final unit in units) {
      if (unit.unitNo % 2 == 0) {
        resultUnits.add(unit);
      }
    }
    return resultUnits;
  }

  @override
  Future<List<Unit>> getByCategory(
    int categoryNo,
  ) async {
    final db = AppDatabase.instance.database;

    final result = await db.query(
      'units',
      where: 'category_no = ?',
      whereArgs: [categoryNo],
      orderBy: 'unit_no',
    );

    return result.map((map) => UnitMapper.fromMap(map)).toList();
  }

  @override
  Future<String> getUnitDescription(int categoryNo, int unitNo) async {
    final db = AppDatabase.instance.database;

    final result = await db.query(
      'units',
      where: 'category_no = ? AND unit_no = ?',
      whereArgs: [categoryNo, unitNo],
    );
    final units = result.map((map) => UnitMapper.fromMap(map)).toList();
    if (units.isEmpty) {
      throw StateError(
        'Unit not found: categoryNo=$categoryNo, unitNo=$unitNo',
      );
    }
    return "${units[0].unitName} : ${units[0].unitDescription}";
  }

  @override
  Future<List<Unit>> getAllApi() async {
    final response = await apiClient.post(
      '/flash_english_backend/api/get-all-units',
      body: {},
    );

    if (response.statusCode != 200) {
      debugPrint('Failed to fetch units from API');
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      throw Exception('Failed to fetch units from API');
    }
    debugPrint('Response body: ${response.body}');
    final decoded = jsonDecode(response.body);

    if (decoded == null) return [];

    final List data = decoded['units'] as List;

    return data.map((e) => UnitMapper.fromMap(e)).toList();
  }

  @override
  Future<void> insertAll(List<Unit> units) async {
    final db = AppDatabase.instance.database;
    await db.transaction((txn) async {
      await txn.delete('units');
      final batch = txn.batch();
      for (final unit in units) {
        batch.insert(
          'units',
          UnitMapper.toMap(unit),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }
}
