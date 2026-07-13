import 'package:flash_english/domain/entities/unit_score.dart';
import 'package:flash_english/presentation/providers/auth/auth_provider.dart';
import 'package:flash_english/presentation/providers/unit_score/get_unit_score_usecase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unitScoresProvider =
    FutureProvider.family<List<UnitScore>, int>((ref, categoryNo) async {
  debugPrint("unitScoresProvider 再取得: $categoryNo");

  final scoreUseCase = ref.watch(getUnitScoreUseCaseProvider);
  final auth = ref.watch(authProvider);
  final result = await scoreUseCase.getAll(categoryNo, auth);
  for (final s in result) {
    debugPrint(
      'category=${s.categoryNo}, unit=${s.unitNo}, stars=${s.stars}',
    );
  }
  debugPrint("取得件数: ${result.length}");
  return result;
});
