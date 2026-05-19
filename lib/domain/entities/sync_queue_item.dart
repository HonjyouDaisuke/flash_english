import 'dart:convert';

enum SyncStatus {
  pending,
  processing,
  completed,
  failed,
}

class SyncQueueItem {
  final int? id;
  final String eventId;
  final String type;
  final String userId;
  final String payload;
  final SyncStatus status;
  final int retryCount;
  final DateTime createdAt;

  const SyncQueueItem({
    this.id,
    required this.eventId,
    required this.type,
    required this.userId,
    required this.payload,
    required this.status,
    required this.retryCount,
    required this.createdAt,
  });

  factory SyncQueueItem.fromMap(Map<String, dynamic> map) {
    return SyncQueueItem(
      id: map['id'] as int?,
      eventId: map['event_id'] as String,
      type: map['type'] as String,
      userId: map['user_id'] as String,
      payload: map['payload'] as String,
      status: map['status'] is SyncStatus
          ? map['status'] as SyncStatus
          : SyncStatus.values.firstWhere(
              (value) => value.toString().split('.').last == map['status'],
              orElse: () => SyncStatus.pending,
            ),
      retryCount: map['retry_count'] as int,
      createdAt: map['created_at'] is String
          ? DateTime.parse(map['created_at'] as String)
          : map['created_at'] as DateTime,
    );
  }

  Map<String, dynamic> toJson() {
    dynamic decodedPayload;
    try {
      decodedPayload = jsonDecode(payload);
    } catch (_) {
      decodedPayload = payload; // もしくは {} など運用方針に合わせる
    }
    return {
      'event_id': eventId,
      'type': type,
      'user_id': userId,
      'payload': decodedPayload,
      'status': status.name,
      'retry_count': retryCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
