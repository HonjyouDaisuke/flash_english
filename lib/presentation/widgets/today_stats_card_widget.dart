import 'package:flash_english/domain/entities/daily_stats.dart';
import 'package:flutter/material.dart';

class TodayStatsCardWidget extends StatelessWidget {
  final DailyStats stats;

  const TodayStatsCardWidget({super.key, required this.stats});

  String formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes分$seconds秒';
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
              '今日の学習',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _row('学習時間', formatDuration(stats.studyTime)),
            _row('センテンス数', '${stats.sentenceCount}'),
            _row('正解数', '${stats.correctCount}'),
            _row('不正回数', '${stats.wrongCount}'),
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
}
