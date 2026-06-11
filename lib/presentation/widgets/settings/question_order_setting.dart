import 'package:flash_english/presentation/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionOrderSetting extends ConsumerWidget {
  const QuestionOrderSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);

    final value = settings['question_order'] ?? 'random';

    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: value,
      decoration: const InputDecoration(
        labelText: '出題順',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: 'sequential',
          child: Text('順番'),
        ),
        DropdownMenuItem(
          value: 'random',
          child: Text('ランダム'),
        ),
        DropdownMenuItem(
          value: 'weak_first',
          child: Text('苦手優先'),
        ),
      ],
      onChanged: (newValue) async {
        if (newValue == null) return;

        await ref
            .read(userSettingsProvider.notifier)
            .setString('question_order', newValue);
      },
    );
  }
}
