import 'package:flutter/material.dart';
import 'package:flash_english/domain/repositories/user_settings_repository.dart';

class ThemeState extends ChangeNotifier {
  ThemeState(this._repository);

  final UserSettingsRepository _repository;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    final value = await _repository.getString('theme_mode');

    _themeMode = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    notifyListeners();
  }

  Future<void> setThemeMode(
    ThemeMode mode,
  ) async {
    _themeMode = mode;

    await _repository.setString(
      'theme_mode',
      mode.name,
    );

    notifyListeners();
  }
}
