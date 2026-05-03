import 'dart:convert';
import 'package:flash_english/domain/entities/category.dart';
import 'package:flutter/services.dart';

class CategoryLocalDataSource {
  Future<List<Category>> loadCategories() async {
    final jsonString = await rootBundle.loadString('assets/category_tbl.json');
    final List data = jsonDecode(jsonString);

    return data
        .map((e) => Category(
              categoryId: e['category_id'] as int,
              categoryNo: e['category_no'] as int,
              categoryName: e['category_name'] as String,
              categoryDescription: e['category_description'] as String,
            ))
        .toList();
  }
}
