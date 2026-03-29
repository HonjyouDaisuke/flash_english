import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  /// DB取得（シングルトン）
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  /// DB初期化
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 2,
      onCreate: createDB,
    );
  }

  /// テーブル作成
  Future<void> createDB(DatabaseExecutor db, int version) async {
    // questionsテーブル
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
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
        FOREIGN KEY (session_id) REFERENCES study_sessions(id)
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
}
