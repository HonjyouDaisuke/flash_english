import 'package:flash_english/domain/repositories/user_settings_repository.dart';
import 'package:flash_english/presentation/providers/user_setting/user_settings_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userSettingsProvider =
    StateNotifierProvider<SettingsNotifier, Map<String, String>>((ref) {
  final repository = ref.read(userSettingsRepositoryProvider);

  return SettingsNotifier(repository);
});

class SettingsNotifier extends StateNotifier<Map<String, String>> {
  final UserSettingsRepository repository;

  SettingsNotifier(this.repository) : super({});

  Future<void> load() async {
    final settings = await repository.getAll();

    state = {
      for (final s in settings) s.settingKey: s.value,
    };
  }

  Future<void> setString(
    String key,
    String value,
  ) async {
    await repository.setString(
      key,
      value,
    );

    state = {
      ...state,
      key: value,
    };
  }

  Future<void> setInt(
    String key,
    int value,
  ) async {
    await setString(
      key,
      value.toString(),
    );
  }

  Future<void> setBool(
    String key,
    bool value,
  ) async {
    await setString(
      key,
      value.toString(),
    );
  }
}
