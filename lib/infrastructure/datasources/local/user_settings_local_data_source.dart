import 'package:sqflite/sqflite.dart';

class UserSettingsLocalDataSource {
  final Database db;

  UserSettingsLocalDataSource(this.db);

  Future<void> save({
    required String key,
    required String value,
    required DateTime updatedAt,
  }) async {
    await db.insert(
      'user_settings',
      {
        'setting_key': key,
        'value': value,
        'updated_at': updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> get(String key) async {
    final result = await db.query(
      'user_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['value'] as String;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    return db.query('user_settings');
  }
}
