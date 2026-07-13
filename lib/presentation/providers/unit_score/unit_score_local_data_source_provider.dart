import 'package:flash_english/infrastructure/datasources/local/unit_score_local_data_source.dart';
import 'package:flash_english/presentation/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unitScoreLocalDataSourceProvider =
    Provider<UnitScoreLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);
  return UnitScoreLocalDataSource(db);
});
