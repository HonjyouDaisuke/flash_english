import 'package:flash_english/domain/entities/category.dart';
import 'package:flash_english/domain/repositories/category_repository.dart';
import 'package:flutter/material.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call() {
    return repository.getAll();
  }

  Future<List<Category>> callApi() {
    debugPrint("getAllApiスタート");
    return repository.getAllApi();
  }
}
