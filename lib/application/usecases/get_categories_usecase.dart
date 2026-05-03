import 'package:flash_english/domain/entities/category.dart';
import 'package:flash_english/domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call() {
    return repository.getAll();
  }
}
