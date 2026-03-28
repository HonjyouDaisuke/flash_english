import 'package:flash_english/application/usecases/reset_app_usecase.dart';
import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';
import 'package:flash_english/infrastructure/persistence/seed_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainingMenuPage extends StatelessWidget {
  const TrainingMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Text('トレーニング')), // ← これも微妙
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final dataSource = QuestionLocalDataSource();
                    final repository = SeedRepositoryImpl(dataSource);
                    final useCase = ResetAppUseCase(repository);
                    await useCase.execute();
                  },
                  child: const Text('初期化'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push('/training/normal');
                  },
                  child: const Text('通常トレーニング'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push('/training/shuffle');
                  },
                  child: const Text('シャッフル'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
