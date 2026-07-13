import 'package:flash_english/application/usecases/get_user_settings_usecase.dart';
import 'package:flash_english/application/usecases/sync_queue_usecase.dart';
import 'package:flash_english/presentation/providers/user_setting/user_settings_provider.dart';

class SyncUserDataUseCase {
  final SyncQueueUseCase syncQueueUseCase;
  final GetUserSettingsUsecase getUserSettingsUsecase;
  final SettingsNotifier settingsNotifier;

  SyncUserDataUseCase(
    this.syncQueueUseCase,
    this.getUserSettingsUsecase,
    this.settingsNotifier,
  );

  Future<void> execute(String userId) async {
    await syncQueueUseCase.execute(userId);

    await getUserSettingsUsecase.execute(userId);

    await settingsNotifier.load();
  }
}
