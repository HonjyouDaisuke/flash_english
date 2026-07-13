import 'dart:convert';

import 'package:flash_english/core/constants/sync_types.dart';
import 'package:flash_english/domain/entities/sync_queue_item.dart';
import 'package:flash_english/domain/entities/user_setting.dart';
import 'package:flash_english/domain/repositories/sync_queue_repository.dart';
import 'package:flash_english/domain/repositories/user_settings_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/datasources/local/user_settings_local_data_source.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/presentation/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class UserSettingsRepositoryImpl implements UserSettingsRepository {
  final UserSettingsLocalDataSource local;
  final SyncQueueRepository syncQueueRepository;
  final ApiClient apiClient;
  final AuthNotifier authNotifier;
  UserSettingsRepositoryImpl({
    required this.local,
    required this.syncQueueRepository,
    required this.apiClient,
    required this.authNotifier,
  });

  @override
  Future<void> saveAll(List<UserSetting> userSettings, String userId) async {
    final payload = jsonEncode(userSettings.map((s) => s.toJson()).toList());
    debugPrint('ユーザ設定を保存します...');
    const uuid = Uuid();

    final item = SyncQueueItem(
      userId: userId,
      eventId: uuid.v4(),
      type: SyncTypes.userSetting,
      payload: payload,
      status: SyncStatus.pending,
      retryCount: 0,
      createdAt: DateTime.now(),
    );

    await syncQueueRepository.enqueue(item);
  }

  @override
  Future<void> setString(
    String key,
    String value,
  ) async {
    final now = DateTime.now();

    await local.save(
      key: key,
      value: value,
      updatedAt: now,
    );
    final userId = authNotifier.userId;

    if (userId == null) {
      debugPrint("ユーザがログインしていないため、設定の同期をスキップします。");
      return;
    }
    final item = SyncQueueItem(
      userId: userId,
      eventId: const Uuid().v4(),
      type: SyncTypes.userSetting,
      payload: jsonEncode({
        'setting_key': key,
        'value': value,
        'updated_at': now.toIso8601String(),
      }),
      status: SyncStatus.pending,
      retryCount: 0,
      createdAt: now,
    );

    await syncQueueRepository.enqueue(item);
  }

  @override
  Future<void> setInt(
    String key,
    int value,
  ) async {
    await setString(
      key,
      value.toString(),
    );
  }

  @override
  Future<void> setBool(
    String key,
    bool value,
  ) async {
    await setString(
      key,
      value.toString(),
    );
  }

  @override
  Future<String?> getString(String key) {
    return local.get(key);
  }

  @override
  Future<int?> getInt(String key) async {
    final value = await local.get(key);

    if (value == null) {
      return null;
    }

    return int.tryParse(value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = await local.get(key);

    if (value == null) {
      return null;
    }

    return value == 'true';
  }

  @override
  Future<List<UserSetting>> getAll() async {
    final rows = await local.getAll();

    return rows.map((e) {
      return UserSetting(
        settingKey: e['setting_key'] as String,
        value: e['value'] as String,
        updatedAt: DateTime.parse(
          e['updated_at'] as String,
        ),
      );
    }).toList();
  }

  @override
  Future<bool> insertIfAbsent({
    required String settingKey,
    required String value,
  }) async {
    final db = AppDatabase.instance.database;

    final result = await db.insert(
      'user_settings',
      {
        'setting_key': settingKey,
        'value': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM user_settings'),
    );

    debugPrint('user_settings count = $count');
    debugPrint(
        'insertIfAbsent result: $result (settingKey: $settingKey, value: $value) result = $result');
    return result > 0;
  }

  @override
  Future<List<UserSetting>> getAllAPI(String userId) async {
    try {
      final response = await apiClient.post(
        '/flash_english_backend/api/getall-user-settings',
        body: {
          'user_id': userId,
        },
      );
      debugPrint(
          "---------get user setting ---------------- status=${response.statusCode}");
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint("Error get All unit score: status ${response.statusCode}");
        return [];
      }
      final decoded = jsonDecode(response.body);

      if (decoded == null) return [];

      final List data = decoded;

      return data.map((e) => UserSetting.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error get All user settings: $e");
      return [];
    }
  }
}
