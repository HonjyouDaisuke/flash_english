import 'package:flash_english/presentation/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FontSizeSetting extends ConsumerStatefulWidget {
  const FontSizeSetting({super.key});

  @override
  ConsumerState<FontSizeSetting> createState() => _FontSizeSettingState();
}

class _FontSizeSettingState extends ConsumerState<FontSizeSetting> {
  double? _fontSize;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(userSettingsProvider);

    _fontSize ??= double.tryParse(settings['font_size'] ?? '16') ?? 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'フォントサイズ (${_fontSize!.toInt()})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          value: _fontSize!,
          min: 12,
          max: 24,
          divisions: 6,
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
          },
          onChangeEnd: (value) async {
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
