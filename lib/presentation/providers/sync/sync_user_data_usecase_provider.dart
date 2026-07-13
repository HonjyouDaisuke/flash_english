import 'package:flash_english/application/usecases/sync_user_data_usecase.dart';
import 'package:flash_english/presentation/providers/sync/sync_queue_provider.dart';
import 'package:flash_english/presentation/providers/user_setting/get_user_settings_usecase_provider.dart';
import 'package:flash_english/presentation/providers/user_setting/user_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncUserDataUseCaseProvider = Provider<SyncUserDataUseCase>((ref) {
  return SyncUserDataUseCase(
    ref.watch(syncQueueUseCaseProvider),
    ref.watch(getUserSettingsUsecaseProvider),
    ref.watch(userSettingsProvider.notifier),
  );
});
