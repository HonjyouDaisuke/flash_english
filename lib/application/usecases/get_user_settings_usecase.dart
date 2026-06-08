import 'package:flash_english/domain/repositories/user_settings_repository.dart';

class GetUserSettingsUsecase {
  final UserSettingsRepository repository;

  const GetUserSettingsUsecase(this.repository);

  Future<void> execute(String userId) async {
    final settings = await repository.getAllAPI(userId);

    for (final setting in settings) {
      await repository.insertIfAbsent(
        settingKey: setting.settingKey,
        value: setting.value,
      );
    }
  }
}
