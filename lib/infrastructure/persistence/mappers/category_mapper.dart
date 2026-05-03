import 'package:flash_english/domain/entities/category.dart';

class CategoryMapper {
  static Map<String, dynamic> toMap(Category q) {
    return {
      'category_id': q.categoryId,
      'category_no': q.categoryNo,
      'category_name': q.categoryName,
      'category_description': q.categoryDescription,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['category_id'],
      categoryNo: map['category_no'],
      categoryName: map['category_name'],
      categoryDescription: map['category_description'],
    );
  }
}
