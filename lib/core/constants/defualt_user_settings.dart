import 'package:flash_english/core/constants/user_setting_keys.dart';
import 'package:flash_english/domain/entities/user_setting.dart';

class DefaultUserSettings {
  static List<UserSetting> create() {
    final now = DateTime.now();

    return [
      UserSetting(
        settingKey: UserSettingKeys.answerWaitSec,
        value: '3',
        updatedAt: now,
      ),
      UserSetting(
        settingKey: UserSettingKeys.themeMode,
        value: 'system',
        updatedAt: now,
      ),
      UserSetting(
        settingKey: UserSettingKeys.soundEnabled,
        value: 'true',
        updatedAt: now,
      ),
      UserSetting(
        settingKey: UserSettingKeys.questionOrder,
        value: 'random',
        updatedAt: now,
      ),
      UserSetting(
        settingKey: UserSettingKeys.fontSize,
        value: '16',
        updatedAt: now,
      ),
    ];
  }
}
