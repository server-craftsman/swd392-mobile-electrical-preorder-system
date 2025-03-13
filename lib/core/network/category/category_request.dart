import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import 'package:mobile_electrical_preorder_system/core/constants/api_endpoints.dart';

class CategoryRequest {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>?> fetchCategories() async {
    final response = await _apiClient.get(API_PATH.CATEGORIES);
    return response.data as Map<String, dynamic>?;
  }
}
