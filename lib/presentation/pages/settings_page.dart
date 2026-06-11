import 'package:flash_english/presentation/widgets/settings/answer_wait_setting.dart';
import 'package:flash_english/presentation/widgets/settings/font_size_setting.dart';
import 'package:flash_english/presentation/widgets/settings/question_order_setting.dart';
import 'package:flash_english/presentation/widgets/settings/sound_enabled_setting.dart';
import 'package:flash_english/presentation/widgets/settings/theme_mode_setting.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('学習設定'),
          const SizedBox(height: 12),
          _buildCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '回答待ち時間',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                AnswerWaitSetting(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            child: const QuestionOrderSetting(),
          ),
          const SizedBox(height: 16),
          _buildCard(
            child: const SoundEnabledSetting(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('表示設定'),
          const SizedBox(height: 12),
          _buildCard(
            child: const ThemeModeSetting(),
          ),
          const SizedBox(height: 16),
          _buildCard(
            child: const FontSizeSetting(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('アカウント'),
          const SizedBox(height: 12),
          _buildCard(
            child: const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text('アバター設定'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('データ'),
          const SizedBox(height: 12),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '学習記録のリセット',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '学習履歴・スター・正答率を削除します。',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    onPressed: () {
                      _showResetDialog(context);
                    },
                    child: const Text('リセット'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  static void _showResetDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('学習記録をリセット(作成中)'),
          content: const Text(
            '本当に削除しますか？\nこの操作は元に戻せません。',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text('学習記録をリセットする予定です(作成中)'),
                  ),
                );
              },
              child: const Text('削除'),
            ),
          ],
        );
      },
    );
  }
}
