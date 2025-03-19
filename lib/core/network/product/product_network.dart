import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import './res/index.dart';
import './req/index.dart';

class ProductNetwork {
  static Future<ProductResponse> getProductList() async {
    try {
      final response = await ApiClient().get('/products');

      // Validate response format
      if (response.data == null) {
        throw Exception('Invalid response data: null');
      }

      return ProductResponse.fromJson(response.data);
    } catch (e) {
      print('Error in getProductList: $e');
      // Return empty response instead of throwing
      return ProductResponse(
        message: 'Failed to load products: $e',
        data: ProductData(
          content: [],
          totalPages: 0,
          totalElements: 0,
          first: true,
          last: true,
          size: 0,
          number: 0,
        ),
      );
    }
  }

  static Future<int> countProduct() async {
    try {
      final response = await ApiClient().get('/products/count');
      return response.data['data'] as int;
    } catch (e) {
      print('Error in countProduct: $e');
      return 0; // Return 0 as fallback
    }
  }
}
