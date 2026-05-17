import 'package:flash_english/domain/entities/sync_queue_item.dart';

abstract interface class SyncQueueRepository {
  Future<void> enqueue(SyncQueueItem item);

  Future<List<SyncQueueItem>> getPending(String userId);

  Future<void> markProcessing(List<String> ids);

  Future<void> markCompleted(List<String> ids);

  Future<void> markFailed(List<String> ids);

  Future<void> incrementRetry(String id);

  Future<void> deleteByIds(List<String> ids);
}
