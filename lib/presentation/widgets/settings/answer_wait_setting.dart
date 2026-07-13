import 'package:flash_english/presentation/providers/user_setting/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnswerWaitSetting extends ConsumerWidget {
  const AnswerWaitSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);

    final parsed = int.tryParse(settings['answer_wait'] ?? '');
    final answerWait = ({1, 3, 5}.contains(parsed)) ? parsed! : 3;

    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 1, label: Text('1秒')),
        ButtonSegment(value: 3, label: Text('3秒')),
        ButtonSegment(value: 5, label: Text('5秒')),
      ],
      selected: {answerWait},
      onSelectionChanged: (value) async {
        await ref.read(userSettingsProvider.notifier).setInt(
              'answer_wait',
              value.first,
            );
      },
    );
  }
}
