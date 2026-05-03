import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flash_english/application/usecases/get_unit_description_usecase.dart';

import 'unit_repository_provider.dart';

final unitDescriptionProvider = FutureProvider.family<
    String,
    ({
      int categoryId,
      int unitId,
    })>((ref, param) async {
  final useCase = GetUnitDescriptionUseCase(
    ref.read(
      unitRepositoryProvider,
    ),
  );

  return useCase.execute(
    param.categoryId,
    param.unitId,
  );
});
