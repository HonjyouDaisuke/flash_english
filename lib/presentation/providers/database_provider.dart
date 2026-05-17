import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = Provider<Database>(
  (ref) {
    return AppDatabase.instance.database;
  },
);
