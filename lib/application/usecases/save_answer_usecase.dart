import 'dart:convert';

import 'package:flash_english/domain/entities/sync_queue_item.dart';
import 'package:flash_english/domain/repositories/study_repository.dart';
import 'package:flash_english/domain/repositories/sync_queue_repository.dart';
import 'package:uuid/uuid.dart';

class SaveAnswerUseCase {
  final StudyRepository repository;
  final SyncQueueRepository queueRepository;

  SaveAnswerUseCase(
    this.repository,
    this.queueRepository,
  );

  Future<void> execute({
    required String id,
    required int questionId,
    required int categoryNo,
    required int unitNo,
    required int questionNo,
    required bool isCorrect,
    required int sessionId,
    required String userId,
    required int durationSeconds,
  }) async {
    await repository.saveAnswer(
        id: id,
        questionId: questionId,
        categoryNo: categoryNo,
        unitNo: unitNo,
        questionNo: questionNo,
        isCorrect: isCorrect,
        sessionId: sessionId,
        durationSeconds: durationSeconds);
    // Enqueue the study_log to the sync queue
    await queueRepository.enqueue(
      SyncQueueItem(
        userId: userId,
        eventId: const Uuid().v4(),
        type: 'study_log',
        payload: jsonEncode({
          'id': id,
          'category_no': categoryNo,
          'unit_no': unitNo,
          'question_no': questionNo,
          'is_correct': isCorrect,
          'session_id': sessionId,
          'duration_seconds': durationSeconds,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        }),
        status: SyncStatus.pending,
        retryCount: 0,
        createdAt: DateTime.now(),
      ),
    );
  }
}
