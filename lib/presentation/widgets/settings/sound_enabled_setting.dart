import 'package:flash_english/presentation/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoundEnabledSetting extends ConsumerWidget {
  const SoundEnabledSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);

    final enabled = (settings['sound_enabled'] ?? 'true') == 'true';

    return SwitchListTile(
      title: const Text('音声再生'),
      value: enabled,
      onChanged: (value) async {
        await ref.read(userSettingsProvider.notifier).setBool(
              'sound_enabled',
              value,
            );
      },
    );
  }
}
