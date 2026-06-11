import 'package:flash_english/infrastructure/datasources/local/user_settings_local_data_source.dart';
import 'package:flash_english/presentation/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userSettingsLocalDataSourceProvider =
    Provider<UserSettingsLocalDataSource>((ref) {
  final db = ref.read(databaseProvider);

  return UserSettingsLocalDataSource(db);
});
