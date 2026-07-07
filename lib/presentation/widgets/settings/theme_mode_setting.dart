import 'package:flash_english/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeSetting extends ConsumerWidget {
  const ThemeModeSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeStateProvider);

    final value = switch (themeState.themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };

    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: value,
      decoration: const InputDecoration(
        labelText: 'テーマ',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: 'light',
          child: Text('ライト'),
        ),
        DropdownMenuItem(
          value: 'dark',
          child: Text('ダーク'),
        ),
        DropdownMenuItem(
          value: 'system',
          child: Text('システム'),
        ),
      ],
      onChanged: (newValue) async {
        if (newValue == null) return;
        final mode = switch (newValue) {
          'light' => ThemeMode.light,
          'dark' => ThemeMode.dark,
          _ => ThemeMode.system,
        };

        await ref.read(themeStateProvider).setThemeMode(mode);
      },
    );
  }
}
