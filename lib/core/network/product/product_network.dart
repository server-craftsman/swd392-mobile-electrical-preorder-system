import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import './res/index.dart';
import './req/index.dart';

class ProductNetwork {
  static Future<ProductResponse> getProductList() async {
    final response = await ApiClient().get('/products');

    return ProductResponse.fromJson(response.data);
  }

  static Future<int> countProduct() async {
    final response = await ApiClient().get('/products/count');
    return response.data['data'] as int;
  }
}
