import 'package:flash_english/domain/entities/daily_stats.dart';
import 'package:flutter/material.dart';

class TodayStatsCardWidget extends StatelessWidget {
  final DailyStats stats;
  final DateTime? date;

  const TodayStatsCardWidget({super.key, required this.stats, this.date});

  String formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes分$seconds秒';
  }

  String _title() {
    final targetDate = date ?? DateTime.now();
    final today = DateTime.now();

    final isToday = targetDate.year == today.year &&
        targetDate.month == today.month &&
        targetDate.day == today.day;

    if (isToday) {
      return '今日の学習';
    }

    const weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[targetDate.weekday - 1];

    return '${targetDate.year}年'
        '${targetDate.month}月'
        '${targetDate.day}日'
        '($weekday)'
        'の学習状況';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _row('学習時間', formatDuration(stats.studyTime)),
            _row('センテンス数', '${stats.sentenceCount}'),
            // _row('正解数', '${stats.correctCount}'),
            // _row('不正解数', '${stats.wrongCount}'),
            _resultBar(),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _resultBar() {
    final total = stats.correctCount + stats.wrongCount;

    if (total == 0) {
      return const Text('まだ学習していません');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '回答結果',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 12,
            child: Row(
              children: [
                if (stats.correctCount > 0)
                  Expanded(
                    flex: stats.correctCount,
                    child: Container(color: Colors.green),
                  ),
                if (stats.wrongCount > 0)
                  Expanded(
                    flex: stats.wrongCount,
                    child: Container(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('✅ ${stats.correctCount}'),
            Text(
              '${(stats.correctCount / total * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('❌ ${stats.wrongCount}'),
          ],
        ),
      ],
    );
  }
}
