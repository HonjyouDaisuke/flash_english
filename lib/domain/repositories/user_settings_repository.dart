import 'package:flash_english/domain/entities/user_setting.dart';

abstract class UserSettingsRepository {
  Future<void> setString(
    String key,
    String value,
  );

  Future<void> setInt(
    String key,
    int value,
  );

  Future<void> setBool(
    String key,
    bool value,
  );

  Future<String?> getString(String key);

  Future<int?> getInt(String key);

  Future<bool?> getBool(String key);

  Future<List<UserSetting>> getAll();
  Future<List<UserSetting>> getAllAPI(String userId);
  Future<void> saveAll(List<UserSetting> settings, String userId);

  Future<bool> insertIfAbsent({
    required String settingKey,
    required String value,
  });
}
