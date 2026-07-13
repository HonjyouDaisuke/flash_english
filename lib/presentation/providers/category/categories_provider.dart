import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flash_english/domain/entities/category.dart';

import 'get_categories_usecase_provider.dart';

final categoriesProvider = FutureProvider<List<Category>>((
  ref,
) async {
  final useCase = ref.read(
    getCategoriesUseCaseProvider,
  );

  return useCase.call();
});
