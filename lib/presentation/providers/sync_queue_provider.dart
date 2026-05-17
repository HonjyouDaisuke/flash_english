import 'package:flash_english/application/usecases/sync_queue_usecase.dart';
import 'package:flash_english/domain/repositories/sync_queue_repository.dart';
import 'package:flash_english/infrastructure/datasources/local/sync_queue_local_data_source.dart';
import 'package:flash_english/infrastructure/repositories/sync_queue_repository_impl.dart';
import 'package:flash_english/presentation/providers/api_client_provider.dart';
import 'package:flash_english/presentation/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncQueueLocalDataSourceProvider = Provider<SyncQueueLocalDataSource>(
  (ref) {
    final db = ref.watch(
      databaseProvider,
    );

    return SyncQueueLocalDataSource(
      db,
    );
  },
);

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>(
  (ref) {
    final localDataSource = ref.watch(
      syncQueueLocalDataSourceProvider,
    );

    return SyncQueueRepositoryImpl(
      localDataSource,
    );
  },
);

final syncQueueUseCaseProvider = Provider<SyncQueueUseCase>(
  (ref) {
    final repository = ref.watch(
      syncQueueRepositoryProvider,
    );

    final apiClient = ref.watch(
      apiClientProvider,
    );

    return SyncQueueUseCase(
      repository: repository,
      apiClient: apiClient,
    );
  },
);
