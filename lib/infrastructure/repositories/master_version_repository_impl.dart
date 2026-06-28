import 'dart:convert';

import 'package:flash_english/domain/entities/master_version.dart';
import 'package:flash_english/domain/repositories/master_version_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/persistence/mappers/master_version_mapper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class MasterVersionRepositoryImpl implements MasterVersionRepository {
  final ApiClient apiClient;
  MasterVersionRepositoryImpl(this.apiClient);

  @override
  Future<bool> isNeedUpdate(
    String versionName,
  ) async {
    final currentVersion = await getLoalVersion(versionName);
    final response = await apiClient.post(
      '/flash_english_backend/api/check-master-version',
      body: {
        'version_name': versionName,
        'current_version': currentVersion.versionNo,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to check master version');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return decoded['is_need_update'] as bool;
  }

  @override
  Future<MasterVersion> getLoalVersion(String versionName) async {
    final db = AppDatabase.instance.database;

    final result = await db.query(
      'master_versions',
      where: 'version_name = ?',
      whereArgs: [versionName],
      limit: 1,
    );

    if (result.isEmpty) {
      throw Exception('MasterVersion not found: $versionName');
    }

    return MasterVersionMapper.fromMap(result.first);
  }

  @override
  Future<MasterVersion> getVersionApi(
    String versionName,
  ) async {
    final response = await apiClient.post(
      '/flash_english_backend/api/get-master-version',
      body: {
        'version_name': versionName,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to check master version');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return MasterVersionMapper.fromMap(
      decoded['master_version'] as Map<String, dynamic>,
    );
  }

  @override
  Future<bool> saveVersion(MasterVersion currentVersion) async {
    final db = AppDatabase.instance.database;
    debugPrint(
      'Version Save name=${currentVersion.versionName} - ver: ${currentVersion.versionNo}',
    );
    await db.insert(
      'master_versions',
      MasterVersionMapper.toMap(currentVersion),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }
}
