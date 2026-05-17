import 'dart:convert';

import 'package:flash_english/domain/constants/sync_types.dart';
import 'package:flash_english/domain/entities/study_log.dart';
import 'package:flash_english/domain/entities/sync_queue_item.dart';
import 'package:flash_english/domain/repositories/sync_queue_repository.dart';
import 'package:uuid/uuid.dart';

class EnqueueStudyLogUseCase {
  final SyncQueueRepository queueRepository;
  EnqueueStudyLogUseCase(this.queueRepository);

  Future<void> call(StudyLog log, String userId) async {
    final payload = jsonEncode(log.toJson());

    const uuid = Uuid();

    final item = SyncQueueItem(
      userId: userId,
      eventId: uuid.v4(),
      type: SyncTypes.studyLog,
      payload: payload,
      status: SyncStatus.pending,
      retryCount: 0,
      createdAt: DateTime.now(),
    );

    await queueRepository.enqueue(item);
  }
}
