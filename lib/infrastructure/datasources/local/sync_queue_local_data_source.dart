import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SyncQueueLocalDataSource {
  final Database _database;

  SyncQueueLocalDataSource(this._database);

  Future<void> insert(Map<String, dynamic> data) async {
    debugPrint('Inserting sync item into local DB: ${data['event_id']}');
    await _database.insert(
      'sync_queue',
      data,
    );
  }

  Future<List<Map<String, dynamic>>> getPending(
    String userId,
  ) async {
    return _database.query(
      'sync_queue',
      where: 'user_id = ?',
      whereArgs: [
        userId,
      ],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> deleteByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return;

    final placeholders = List.filled(ids.length, '?').join(',');

    await _database.delete(
      'sync_queue',
      where: 'event_id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  Future<void> updateStatus(
    List<String> ids,
    String status,
  ) async {
    if (ids.isEmpty) return;
    final placeholders = List.filled(ids.length, '?').join(',');
    await _database.update(
      'sync_queue',
      {
        'status': status,
      },
      where: 'event_id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  Future<void> incrementRetry(
    String id,
  ) async {
    await _database.rawUpdate(
      '''
    UPDATE sync_queue
    SET retry_count = retry_count + 1
    WHERE event_id = ?
    ''',
      [id],
    );
  }
}
