import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;
  Future<Database>? _openingFuture;

  AppDatabase._init();
  Future<void> init() async {
    if (_database != null) {
      return;
    }

    _openingFuture ??= _initDB('app.db');

    _database = await _openingFuture;
  }

  /// DB取得（シングルトン）
  // Future<Database> get database async {
  //   if (_database != null) return _database!;
  //   _database = await _initDB('app.db');
  //   return _database!;
  // }
  Database get database {
    if (_database == null) {
      throw Exception('Database not initialized');
    }

    return _database!;
  }

  /// DB初期化
  Future<Database> _initDB(
    String filePath,
  ) async {
    final dbPath = await getDatabasesPath();

    final path = join(
      dbPath,
      filePath,
    );

    //開発中のみDBを消す！
    await deleteDatabase(path);

    return openDatabase(
      path,
      version: 6,
      onCreate: createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// テーブル作成
  Future<void> createDB(DatabaseExecutor db, int version) async {
    debugPrint("Creating database with version $version");
    // categoriesテーブル
    await db.execute('''
      CREATE TABLE categories (
        category_id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_no INTEGER ,
        category_name TEXT,
        category_description Text
      )
    ''');

    // sync_queueテーブル
    await db.execute('''
      CREATE TABLE sync_queue (
        event_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL,
        payload TEXT NOT NULL,
        status TEXT NOT NULL,
        retry_count INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX idx_sync_queue_user_status
      ON sync_queue(user_id, status);
    ''');

    // unitsテーブル
    await db.execute('''
      CREATE TABLE units (
        unit_id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_no INTEGER ,
        unit_no INTEGER ,
        unit_name TEXT,
        unit_description Text
      )
    ''');

    // questionsテーブル
    await db.execute('''
      CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_no INTEGER ,
        unit_no INTEGER ,
        number INTEGER ,
        japanese TEXT NOT NULL,
        english TEXT NOT NULL,
        audioPath TEXT,
        category TEXT,
        japanese_audio TEXT,
        english_audio TEXT
      )
    ''');

    // 👇 セッションテーブル追加
    await db.execute('''
      CREATE TABLE study_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        started_at TEXT NOT NULL,
        ended_at TEXT
      )
    ''');

    // 👇 ログテーブル修正
    await db.execute('''
      CREATE TABLE study_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER,
        is_correct INTEGER,
        created_at TEXT,
        session_id INTEGER,
        duration INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (session_id) REFERENCES study_sessions(id)
      )
    ''');

    // 👇 ユニットスコアテーブル追加
    await db.execute('''
      CREATE TABLE IF NOT EXISTS unit_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_no INTEGER NOT NULL,
        unit_no INTEGER NOT NULL,
        score INTEGER NOT NULL,
        achieved_at TEXT NOT NULL,
        UNIQUE(category_no, unit_no)
      )
    ''');

    // master_versionsテーブル
    await db.execute('''
      CREATE TABLE master_versions (
        version_id INTEGER PRIMARY KEY,
        version_no VARCHAR(20) NOT NULL,
        version_name TEXT NOT NULL,
        version_description TEXT NOT NULL,
        updated_at TEXT NOT NULL  DEFAULT CURRENT_TIMESTAMP
        );
    ''');

    // user_settingsテーブル
    await db.execute('''
      CREATE TABLE user_settings (
        setting_key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      INSERT INTO master_versions (
        version_id, version_no, version_name, version_description
      )
      VALUES (1, '0.0.0', 'category', 'カテゴリ')
      ''');

    await db.execute('''
      INSERT INTO master_versions (
        version_id, version_no, version_name, version_description
      )
      VALUES (2, '0.0.0', 'unit', 'ユニット')
      ''');

    await db.execute('''
      INSERT INTO master_versions (
        version_id, version_no, version_name, version_description
      )
      VALUES (3, '0.0.0', 'question', '問題')
      ''');
  }

  Future<void> _upgradeDB(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    debugPrint("databese version $oldVersion to $newVersion");
    if (oldVersion < 6) {
      debugPrint(
          "Upgrading database from version--------- $oldVersion to $newVersion");
      await db.execute('''
      DROP TABLE IF EXISTS sync_queue;
      ''');

      await db.execute('''
      CREATE TABLE sync_queue (
        event_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL,
        payload TEXT NOT NULL,
        status TEXT NOT NULL,
        retry_count INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

      await db.execute('''
      CREATE INDEX idx_sync_queue_user_status
      ON sync_queue(user_id, status)
    ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS unit_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_no INTEGER NOT NULL,
        unit_no INTEGER NOT NULL,
        score INTEGER NOT NULL,
        achieved_at TEXT NOT NULL,
        UNIQUE(category_no, unit_no)
      )
    ''');
    }

    if (oldVersion < 6) {
      debugPrint("Upgrading database from version $oldVersion to $newVersion");
      await db.execute('''
      DROP TABLE IF EXISTS user_settings;
      ''');
      await db.execute('''
      CREATE TABLE user_settings (
        setting_key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    }

    if (oldVersion < 6) {
      debugPrint("Upgrading database from version $oldVersion to $newVersion");
      await db.execute('''
      DROP TABLE IF EXISTS master_versions;
    ''');
      await db.execute('''
      CREATE TABLE master_versions (
        version_id INTEGER PRIMARY KEY,
        version_no VARCHAR(20) NOT NULL,
        version_name TEXT NOT NULL,
        version_description TEXT NOT NULL,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
    ''');

      await db.execute('''
        INSERT INTO master_versions (
          version_id, version_no, version_name, version_description
        )
        VALUES (1, '0.0.0', 'category', 'カテゴリ')
        ''');

      await db.execute('''
        INSERT INTO master_versions (
          version_id, version_no, version_name, version_description
        )
        VALUES (2, '0.0.0', 'unit', 'ユニット')
        ''');

      await db.execute('''
        INSERT INTO master_versions (
          version_id, version_no, version_name, version_description
        )
        VALUES (3, '0.0.0', 'question', '問題')
        ''');
    }
  }
}
