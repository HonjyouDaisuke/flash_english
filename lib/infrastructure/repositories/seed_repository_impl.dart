import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';
import 'package:flash_english/infrastructure/persistence/mappers/question_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flash_english/domain/repositories/seed_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../persistence/app_database.dart';
import 'package:flash_english/domain/entities/question.dart';

class SeedRepositoryImpl implements SeedRepository {
  final QuestionLocalDataSource dataSource;

  SeedRepositoryImpl(this.dataSource);

  @override
  Future<bool> needsSeeding(DatabaseExecutor db) async {
    debugPrint("シードが必要か確認します...");
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM questions');
    final count = Sqflite.firstIntValue(result) ?? 0;
    debugPrint("✅ questionsテーブルの件数: $count");
    debugPrint("✅ シードが必要: $count == 0");
    return count == 0;
  }

  @override
  Future<void> setSeeded(DatabaseExecutor db) async {
    await db.insert('settings', {'key': 'seeded', 'value': 'true'});
  }

  @override
  Future<void> seed(DatabaseExecutor db) async {
    debugPrint("シードデータを投入します...");
    final List<Question> questions = await dataSource.loadQuestions();
    debugPrint("✅ シードデータを読み込みました: ${questions.length}件");
    for (final q in questions) {
      await db.insert('questions', QuestionMapper.toMap(q));
    }
    debugPrint("✅ シードデータを投入しました");
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
