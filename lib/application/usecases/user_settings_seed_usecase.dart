import 'dart:convert';

import 'package:flash_english/domain/entities/sync_queue_item.dart';
import 'package:flash_english/domain/repositories/sync_queue_repository.dart';
import 'package:flash_english/domain/repositories/user_settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserSettingsSeedUseCase {
  UserSettingsSeedUseCase(
    this._settingsRepository,
    this._syncQueueRepository,
  );

  final UserSettingsRepository _settingsRepository;
  final SyncQueueRepository _syncQueueRepository;

  Future<void> execute(String userId) async {
    debugPrint('ユーザ設定のシードを開始します...');
    await _seed(
      settingKey: 'answer_wait',
      value: '3',
      userId: userId,
    );

    await _seed(
      settingKey: 'theme_mode',
      value: 'system',
      userId: userId,
    );

    await _seed(
      settingKey: 'sound_enabled',
      value: 'true',
      userId: userId,
    );

    await _seed(
      settingKey: 'question_order',
      value: 'random',
      userId: userId,
    );

    await _seed(
      settingKey: 'font_size',
      value: '16',
      userId: userId,
    );
  }

  Future<void> _seed({
    required String settingKey,
    required String value,
    required String userId,
  }) async {
    final inserted = await _settingsRepository.insertIfAbsent(
      settingKey: settingKey,
      value: value,
    );

    if (!inserted) {
      return;
    }
    // TODO:SyncServerにユーザー設定追加のイベントを送る
    final payload = jsonEncode({
      'setting_key': settingKey,
      'value': value,
    });
    await _syncQueueRepository.enqueue(
      SyncQueueItem(
        userId: userId, // TODO:ユーザーIDを取得する
        eventId: const Uuid().v4(),
        type: 'user_setting',
        payload: payload,
        status: SyncStatus.pending,
        retryCount: 0,
        createdAt: DateTime.now(),
      ),
    );
  }
}
