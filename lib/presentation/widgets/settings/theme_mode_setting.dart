import 'package:flash_english/presentation/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeSetting extends ConsumerWidget {
  const ThemeModeSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);

    final value = settings['theme_mode'] ?? 'system';

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

        await ref
            .read(userSettingsProvider.notifier)
            .setString('theme_mode', newValue);
      },
    );
  }
}
