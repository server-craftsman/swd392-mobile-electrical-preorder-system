import 'package:mobile_electrical_preorder_system/core/network/category/category_model.dart';

class CategoryResponse {
  List<Category> parseCategories(Map<String, dynamic>? data) {
    if (data == null || data['data'] == null) {
      return [];
    }

    return (data['data'] as List).map((e) {
      return Category.fromJson(e as Map<String, dynamic>);
    }).toList();
  }
}
