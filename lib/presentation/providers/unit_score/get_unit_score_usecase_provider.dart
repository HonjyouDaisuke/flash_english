import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/application/usecases/get_unit_score_usecase.dart';
import 'package:flash_english/presentation/providers/unit_score/unit_score_repository_provider.dart';

final getUnitScoreUseCaseProvider = Provider<GetUnitScoreUseCase>((ref) {
  final repo = ref.watch(unitScoreRepositoryProvider);
  return GetUnitScoreUseCase(repo);
});
