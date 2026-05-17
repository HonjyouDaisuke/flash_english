import 'package:flash_english/domain/entities/sync_queue_item.dart';

class SyncQueueModel extends SyncQueueItem {
  const SyncQueueModel({
    required super.eventId,
    required super.userId,
    required super.type,
    required super.payload,
    required super.status,
    required super.retryCount,
    required super.createdAt,
  });

  factory SyncQueueModel.fromEntity(
    SyncQueueItem entity,
  ) {
    return SyncQueueModel(
      eventId: entity.eventId,
      userId: entity.userId,
      type: entity.type,
      payload: entity.payload,
      status: entity.status,
      retryCount: entity.retryCount,
      createdAt: entity.createdAt,
    );
  }

  factory SyncQueueModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return SyncQueueModel(
      eventId: map['event_id'],
      userId: map['user_id'],
      type: map['type'],
      payload: map['payload'],
      status: SyncStatus.values.byName(
        map['status'],
      ),
      retryCount: map['retry_count'],
      createdAt: DateTime.parse(
        map['created_at'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'event_id': eventId,
      'user_id': userId,
      'type': type,
      'payload': payload,
      'status': status.name,
      'retry_count': retryCount,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
