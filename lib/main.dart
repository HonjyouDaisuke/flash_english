import 'package:flash_english/application/usecases/initialize_app_usecase.dart';
import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/repositories/seed_repository_impl.dart';
import 'package:flash_english/presentation/providers/database_provider.dart';
import 'package:flash_english/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await AppDatabase.instance.database;
  final dataSource = QuestionLocalDataSource();
  final seedRepository = SeedRepositoryImpl(dataSource);
  final initializeUseCase = InitializeAppUseCase(seedRepository);

  await initializeUseCase.execute();
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const FlashEnglishApp(),
    ),
  );
  // WidgetsFlutterBinding.ensureInitialized();

  // final dataSource = QuestionLocalDataSource();
  // final seedRepository = SeedRepositoryImpl(dataSource);

  // final initializeUseCase = InitializeAppUseCase(seedRepository);

  // await initializeUseCase.execute();

  // runApp(
  //   const ProviderScope(
  //     child: FlashEnglishApp(),
  //   ),
  // );
}

class FlashEnglishApp extends StatelessWidget {
  const FlashEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
    );
  }
}
