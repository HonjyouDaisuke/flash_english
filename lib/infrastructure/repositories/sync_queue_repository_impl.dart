import 'package:flash_english/domain/entities/sync_queue_item.dart';
import 'package:flash_english/domain/models/sync_queue_model.dart';
import 'package:flash_english/domain/repositories/sync_queue_repository.dart';
import 'package:flash_english/infrastructure/datasources/local/sync_queue_local_data_source.dart';
import 'package:flutter/material.dart';

class SyncQueueRepositoryImpl implements SyncQueueRepository {
  final SyncQueueLocalDataSource _localDataSource;

  SyncQueueRepositoryImpl(
    this._localDataSource,
  );

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    final model = SyncQueueModel.fromEntity(
      item,
    );
    debugPrint('Enqueuing sync item: type=${item.type} eventId=${item.eventId}');

    await _localDataSource.insert(
      model.toMap(),
    );
  }

  @override
  Future<List<SyncQueueItem>> getPending(
    String userId,
  ) async {
    final maps = await _localDataSource.getPending(
      userId,
    );

    return maps
        .map(
          SyncQueueModel.fromMap,
        )
        .toList();
  }

  @override
  Future<void> deleteByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return;

    await _localDataSource.deleteByIds(ids);
  }

  @override
  Future<void> markProcessing(
    List<String> ids,
  ) async {
    await _localDataSource.updateStatus(
      ids,
      SyncStatus.processing.name,
    );
  }

  @override
  Future<void> markCompleted(
    List<String> ids,
  ) async {
    await _localDataSource.updateStatus(
      ids,
      SyncStatus.completed.name,
    );
  }

  @override
  Future<void> markFailed(
    List<String> ids,
  ) async {
    await _localDataSource.updateStatus(
      ids,
      SyncStatus.failed.name,
    );
  }

  @override
  Future<void> incrementRetry(
    String id,
  ) async {
    await _localDataSource.incrementRetry(id);
  }
}
