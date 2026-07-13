import 'package:flash_english/application/usecases/reset_app_usecase.dart';
import 'package:flash_english/infrastructure/datasources/local/category_local_data_source.dart';
import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';
import 'package:flash_english/infrastructure/datasources/local/unit_local_data_source.dart';
import 'package:flash_english/infrastructure/repositories/seed_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainingMenuPage extends StatelessWidget {
  const TrainingMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Text('トレーニング')),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.push('/training/category');
                  },
                  child: const Text('通常トレーニング'),
                ),
                const ElevatedButton(
                  // TODO: シャッフルトレーニングの実装が完了したら有効化する
                  // onPressed: () {
                  //   context.push('/training/shuffle');
                  // },
                  onPressed: null,
                  child: Text('シャッフル'),
                ),
                const ElevatedButton(
                  // TODO: 苦手問題トレーニングの実装が完了したら有効化する
                  // onPressed: () {
                  //   context.push('/training/difficult');
                  // },
                  onPressed: null,
                  child: Text('苦手問題'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final questionDataSource = QuestionLocalDataSource();
                    final unitDataSource = UnitLocalDataSource();
                    final categoryDataSource = CategoryLocalDataSource();
                    final repository = SeedRepositoryImpl(
                        questionDataSource, unitDataSource, categoryDataSource);
                    final useCase = ResetAppUseCase(repository);
                    await useCase.execute();
                  },
                  child: const Text('初期化'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
