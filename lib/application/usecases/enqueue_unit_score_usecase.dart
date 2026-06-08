import 'dart:convert';
import 'package:flash_english/core/constants/sync_types.dart';
import 'package:flash_english/domain/entities/sync_queue_item.dart';
import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/domain/repositories/sync_queue_repository.dart';
import 'package:uuid/uuid.dart';

class EnqueueUnitScoreUseCase {
  final SyncQueueRepository queueRepository;
  EnqueueUnitScoreUseCase(this.queueRepository);

  Future<void> call(UnitScore unitScore, String userId) async {
    final payload = jsonEncode(unitScore.toJson());

    const uuid = Uuid();

    final item = SyncQueueItem(
      userId: userId,
      eventId: uuid.v4(),
      type: SyncTypes.unitScore,
      payload: payload,
      status: SyncStatus.pending,
      retryCount: 0,
      createdAt: DateTime.now(),
    );

    await queueRepository.enqueue(item);
  }
}
