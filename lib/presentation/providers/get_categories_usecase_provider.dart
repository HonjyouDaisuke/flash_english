import 'package:flash_english/application/usecases/get_categories_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/presentation/providers/category_repository_provider.dart';

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  return GetCategoriesUseCase(
    ref.watch(
      categoryRepositoryProvider,
    ),
  );
});
