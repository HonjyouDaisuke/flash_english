import 'package:flash_english/domain/entities/category.dart';
import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/infrastructure/datasources/local/category_local_data_source.dart';
import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';
import 'package:flash_english/infrastructure/datasources/local/unit_local_data_source.dart';
import 'package:flash_english/infrastructure/persistence/mappers/category_mapper.dart';
import 'package:flash_english/infrastructure/persistence/mappers/question_mapper.dart';
import 'package:flash_english/infrastructure/persistence/mappers/unit_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flash_english/domain/repositories/seed_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../persistence/app_database.dart';
import 'package:flash_english/domain/entities/question.dart';

class SeedRepositoryImpl implements SeedRepository {
  final QuestionLocalDataSource questionDataSource;
  final UnitLocalDataSource unitDataSource;
  final CategoryLocalDataSource categoryDataSource;

  SeedRepositoryImpl(
      this.questionDataSource, this.unitDataSource, this.categoryDataSource);

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
    final List<Category> categories = await categoryDataSource.loadCategories();
    debugPrint("✅ categoriesデータを読み込みました: ${categories.length}件");
    for (final c in categories) {
      await db.insert('categories', CategoryMapper.toMap(c));
    }
    debugPrint("✅ categoriesデータを投入しました");

    final List<Unit> units = await unitDataSource.loadUnits();
    debugPrint("✅ Unitsデータを読み込みました: ${units.length}件");
    for (final u in units) {
      await db.insert('units', UnitMapper.toMap(u));
    }
    debugPrint("✅ Unitsデータを投入しました");

    final List<Question> questions = await questionDataSource.loadQuestions();
    debugPrint("✅ Questionsデータを読み込みました: ${questions.length}件");
    for (final q in questions) {
      await db.insert('questions', QuestionMapper.toMap(q));
    }
    debugPrint("✅ Questionsデータを投入しました");
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
