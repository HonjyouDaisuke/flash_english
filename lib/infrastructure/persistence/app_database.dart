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

    return openDatabase(
      path,
      version: 3,
      onCreate: createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// テーブル作成
  Future<void> createDB(DatabaseExecutor db, int version) async {
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
      CREATE TABLE unit_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_no INTEGER NOT NULL,
        unit_no INTEGER NOT NULL,
        score INTEGER NOT NULL,
        achieved_at TEXT NOT NULL,
        UNIQUE(category_no, unit_no)
      )
    ''');

    // settingsテーブル
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Future<void> _upgradeDB(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
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
      CREATE TABLE unit_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_no INTEGER NOT NULL,
        unit_no INTEGER NOT NULL,
        score INTEGER NOT NULL,
        achieved_at TEXT NOT NULL,
        UNIQUE(category_no, unit_no)
      )
    ''');
    }
  }
}
