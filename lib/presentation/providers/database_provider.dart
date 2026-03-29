import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError(
    'database is overridden in main.dart',
  );
});
