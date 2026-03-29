import 'package:flash_english/application/usecases/get_today_stats_usecase.dart';
import 'package:flash_english/domain/entities/daily_stats.dart';
import 'package:flash_english/domain/repositories/study_log_repository.dart';
import 'package:flash_english/presentation/providers/get_today_stats_usecase_provider.dart';
import 'package:flash_english/presentation/widgets/today_stats_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  Future<DailyStats>? _future;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reload();
  }

  void _reload() {
    final usecase = ref.read(getTodayStatsUseCaseProvider);
    setState(() {
      _future = usecase.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DailyStats>(
        future: _future,
        builder: (context, snapshot) {
          if (_future == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('エラー: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('データなし'));
          }

          final stats = snapshot.data!;

          return Column(
            children: [
              const Text('ダッシュボード'),
              TodayStatsCardWidget(stats: stats),
            ],
          );
        },
      ),
    );
  }
}
