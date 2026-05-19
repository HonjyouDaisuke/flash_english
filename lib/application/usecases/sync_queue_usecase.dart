import 'package:flash_english/domain/repositories/sync_queue_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flutter/material.dart';

class SyncQueueUseCase {
  final SyncQueueRepository repository;
  final ApiClient apiClient;

  const SyncQueueUseCase({
    required this.repository,
    required this.apiClient,
  });

  Future<void> execute(String userId) async {
    debugPrint('Starting sync for user: $userId');

    final items = await repository.getPending(userId);

    if (items.isEmpty) {
      debugPrint('No pending items');
      return;
    }

    final ids = items.map((e) => e.eventId).toList();

    await repository.markProcessing(ids);

    try {
      final response = await apiClient.post(
        '/flash_english_backend/api/sync',
        body: {
          'events': items.map((e) => e.toJson()).toList(),
        },
      );
      debugPrint('statusCode: ${response.statusCode}');
      debugPrint('body: ${response.body}');
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('sync failed');
      }
      await repository.deleteByIds(ids);

      debugPrint('Sync completed: ${ids.length} items');
    } catch (_) {
      await repository.markFailed(ids);

      for (final id in ids) {
        await repository.incrementRetry(id);
      }

      rethrow;
    }
  }
}
