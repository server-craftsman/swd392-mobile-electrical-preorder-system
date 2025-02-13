import 'package:mobile_electrical_preorder_system/core/network/category/category_request.dart';
import 'package:mobile_electrical_preorder_system/core/network/category/category_response.dart';
import 'package:mobile_electrical_preorder_system/core/network/category/category_model.dart';
import 'package:mobile_electrical_preorder_system/core/utils/format_response.dart';

class CategoryNetwork {
  final CategoryRequest _categoryRequest = CategoryRequest();
  final CategoryResponse _categoryResponse = CategoryResponse();

  Future<FormatResponse<List<Category>>> getCategories() async {
    final data = await _categoryRequest.fetchCategories();
    return FormatResponse(
        message: true, data: _categoryResponse.parseCategories(data));
  }
}
