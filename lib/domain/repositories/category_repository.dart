import 'package:flash_english/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll();
  Future<List<Category>> getAllApi();
  Future<void> insertAll(List<Category> categories);
}
