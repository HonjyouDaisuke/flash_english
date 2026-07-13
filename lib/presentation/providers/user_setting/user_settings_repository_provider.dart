import 'package:flash_english/domain/repositories/user_settings_repository.dart';
import 'package:flash_english/infrastructure/repositories/user_settings_repository_impl.dart';
import 'package:flash_english/presentation/providers/api_client_provider.dart';
import 'package:flash_english/presentation/providers/auth/auth_provider.dart';
import 'package:flash_english/presentation/providers/sync/sync_queue_provider.dart';
import 'package:flash_english/presentation/providers/user_setting/user_settings_local_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userSettingsRepositoryProvider = Provider<UserSettingsRepository>((ref) {
  final local = ref.watch(
    userSettingsLocalDataSourceProvider,
  );

  final syncQueueRepository = ref.watch(
    syncQueueRepositoryProvider,
  );

  final authNotifier = ref.watch(authProvider.notifier);
  return UserSettingsRepositoryImpl(
    local: local,
    syncQueueRepository: syncQueueRepository,
    apiClient: ref.watch(apiClientProvider),
    authNotifier: authNotifier,
  );
});
