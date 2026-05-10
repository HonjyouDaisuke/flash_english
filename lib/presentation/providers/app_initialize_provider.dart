import 'package:flash_english/application/usecases/app_initialize_usecase.dart';
import 'package:flash_english/application/usecases/initialize_app_usecase.dart';
import 'package:flash_english/application/usecases/ping_usecase.dart';
import 'package:flash_english/infrastructure/datasources/local/category_local_data_source.dart';
import 'package:flash_english/infrastructure/datasources/local/question_local_data_source.dart';
import 'package:flash_english/infrastructure/datasources/local/unit_local_data_source.dart';
import 'package:flash_english/infrastructure/repositories/ping_repository_impl.dart';
import 'package:flash_english/infrastructure/repositories/seed_repository_impl.dart';
import 'package:flash_english/presentation/providers/api_client_provider.dart';
import 'package:flash_english/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appInitializeProvider = Provider((ref) {
  final questionDataSource = QuestionLocalDataSource();
  final unitDataSource = UnitLocalDataSource();
  final categoryDataSource = CategoryLocalDataSource();

  final seedRepository = SeedRepositoryImpl(
    questionDataSource,
    unitDataSource,
    categoryDataSource,
  );

  final initializeUseCase = InitializeAppUseCase(seedRepository);

  final pingRepo = PingRepositoryImpl(ref.read(apiClientProvider));

  final pingUseCase = PingUseCase(pingRepo);

  final authNotifier = ref.read(authProvider.notifier);

  return AppInitializeUseCase(
    initializeAppUseCase: initializeUseCase,
    pingUseCase: pingUseCase,
    authNotifier: authNotifier,
  );
});
