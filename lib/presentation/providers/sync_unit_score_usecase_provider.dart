import 'package:flash_english/application/usecases/sync_unit_score_usecase.dart';
import 'package:flash_english/presentation/providers/unit_score_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncUnitScoreUseCaseProvider = Provider(
  (ref) => SyncUnitScoreUseCase(
    ref.read(unitScoreRepositoryProvider),
  ),
);
