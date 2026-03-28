import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';
import 'package:flash_english/infrastructure/persistence/mappers/question_mapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flash_english/domain/repositories/seed_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import 'package:flash_english/domain/entities/question.dart';

class SeedRepositoryImpl implements SeedRepository {
  static const _seedKey = 'is_seeded';

  final QuestionLocalDataSource dataSource;

  SeedRepositoryImpl(this.dataSource);

  @override
  Future<bool> isSeeded(DatabaseExecutor db) async {
    final result =
        await db.query('settings', where: 'key = ?', whereArgs: ['seeded']);
    return result.isNotEmpty;
  }

  @override
  Future<void> setSeeded(DatabaseExecutor db) async {
    await db.insert('settings', {'key': 'seeded', 'value': 'true'});
  }

  @override
  Future<void> seed(DatabaseExecutor db) async {
    final List<Question> questions = await dataSource.loadQuestions();

    for (final q in questions) {
      await db.insert('questions', QuestionMapper.toMap(q));
    }
  }

  Future<void> safeDelete(DatabaseExecutor txn, String table) async {
    final exists = await txn.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [table],
    );

    if (exists.isNotEmpty) {
      await txn.delete(table);
    }
  }

  @override
  Future<void> reset() async {
    final db = await AppDatabase.instance.database;

    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS study_logs');
      await txn.execute('DROP TABLE IF EXISTS study_sessions');
      await txn.execute('DROP TABLE IF EXISTS questions');
      await txn.execute('DROP TABLE IF EXISTS settings');
      await AppDatabase.instance.createDB(txn, 2);

      await seed(txn);
      await setSeeded(txn);
    });
    debugPrint("データベース作りました。");
  }
}
