import 'package:flash_english/domain/repositories/unit_score_repository.dart';
import 'package:flash_english/infrastructure/repositories/unit_high_score_repository_impl.dart';
import 'package:flash_english/presentation/providers/api_client_provider.dart';
import 'package:flash_english/presentation/providers/unit_score_local_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unitScoreRepositoryProvider = Provider<UnitScoreRepository>((ref) {
  final ds = ref.read(unitScoreLocalDataSourceProvider);
  final apiClient = ref.read(apiClientProvider);
  final local = ref.read(unitScoreLocalDataSourceProvider);
  return UnitScoreRepositoryImpl(ds, apiClient, local);
});
