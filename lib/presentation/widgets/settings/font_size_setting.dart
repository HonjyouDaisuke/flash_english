import 'package:flash_english/presentation/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FontSizeSetting extends ConsumerWidget {
  const FontSizeSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);

    final fontSize = double.tryParse(settings['font_size'] ?? '16') ?? 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'フォントサイズ (${fontSize.toInt()})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          value: fontSize,
          min: 12,
          max: 24,
          divisions: 6,
          label: fontSize.toInt().toString(),
          onChanged: (value) async {
            await ref.read(userSettingsProvider.notifier).setString(
                  'font_size',
                  value.toInt().toString(),
                );
          },
        ),
      ],
    );
  }
}
