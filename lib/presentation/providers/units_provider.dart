import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/presentation/providers/auth_provider.dart';
import 'package:flash_english/presentation/providers/get_units_usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unitsProvider =
    FutureProvider.family<List<Unit>, int>((ref, categoryNo) async {
  final useCase = ref.watch(getUnitsUseCaseProvider);
  final auth = ref.watch(authProvider);

  return useCase(categoryNo, auth.isOffline);
});
