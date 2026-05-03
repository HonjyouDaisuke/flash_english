import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flash_english/domain/repositories/category_repository.dart';

import 'package:flash_english/infrastructure/repositories/category_repository_impl.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl();
});
