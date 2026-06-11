import 'package:sqflite/sqflite.dart';

abstract class SeedRepository {
  Future<void> seed(DatabaseExecutor db);
  Future<bool> needsSeeding(DatabaseExecutor db);
  Future<bool> needsSettingSeeding(DatabaseExecutor db);
  Future<void> reset();
}
