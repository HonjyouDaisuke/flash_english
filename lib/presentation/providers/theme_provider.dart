import 'package:flash_english/presentation/providers/user_settings_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/presentation/providers/theme_state.dart';

final themeStateProvider = ChangeNotifierProvider<ThemeState>((ref) {
  return ThemeState(
    ref.read(userSettingsRepositoryProvider),
  );
});
