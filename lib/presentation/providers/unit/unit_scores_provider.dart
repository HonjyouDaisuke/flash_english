import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/presentation/providers/auth/auth_provider.dart';
import 'package:flash_english/presentation/providers/unit_score/get_unit_score_usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unitScoresProvider =
    FutureProvider.family<List<UnitScore>, int>((ref, categoryNo) async {
  final scoreUseCase = ref.watch(getUnitScoreUseCaseProvider);
  final auth = ref.watch(authProvider);
  final result = await scoreUseCase.getAll(categoryNo, auth);

  return result;
});
