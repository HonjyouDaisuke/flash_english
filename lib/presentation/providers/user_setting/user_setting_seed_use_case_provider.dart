import 'package:flash_english/application/usecases/user_settings_seed_usecase.dart';
import 'package:flash_english/presentation/providers/sync/sync_queue_provider.dart';
import 'package:flash_english/presentation/providers/user_setting/user_settings_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userSettingsSeedUseCaseProvider =
    Provider<UserSettingsSeedUseCase>((ref) {
  return UserSettingsSeedUseCase(
    ref.watch(userSettingsRepositoryProvider),
    ref.watch(syncQueueRepositoryProvider),
  );
});
