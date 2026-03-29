import 'package:sqflite/sqflite.dart';

abstract class SeedRepository {
  Future<void> seed(DatabaseExecutor db);
  Future<bool> needsSeeding(DatabaseExecutor db);
  Future<void> setSeeded(DatabaseExecutor db);
  Future<void> reset();
}
