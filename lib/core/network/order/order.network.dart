import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import 'package:mobile_electrical_preorder_system/core/network/order/res/index.dart';

class OrderNetwork {
  // Use a singleton pattern to ensure only one instance exists
  static final OrderNetwork _instance = OrderNetwork._internal();
  factory OrderNetwork() => _instance;
  OrderNetwork._internal();

  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getOrderList({
    String? name,
    String? status,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        '/orders',
        queryParameters: {
          if (name != null && name.isNotEmpty) 'name': name,
          if (status != null && status.isNotEmpty) 'status': status,
          'page': page.toString(),
          'size': size.toString(),
        },
      );

      // Print response for debugging
      print('API Response: ${response.data}');

      // Default empty result
      Map<String, dynamic> result = {
        'orders': <Order>[],
        'message': 'No orders found',
        'totalAmount': 0,
        'totalPages': 0,
        'totalElements': 0,
        'currentPage': 0,
        'pageSize': size,
      };

      // Check if the response contains the expected data
      if (response.data != null) {
        final responseData = response.data;
        
        // Add message if available
        if (responseData['message'] != null) {
          result['message'] = responseData['message'];
        }
        
        // Check if 'data' field exists in the response
        if (responseData['data'] != null) {
          final data = responseData['data'];
          
          // Check if 'orders' field exists in the data
          if (data['orders'] != null && data['orders'] is List) {
            final List<dynamic> ordersJson = data['orders'];
            
            try {
              final List<Order> orders = ordersJson.map((orderJson) => Order.fromJson(orderJson)).toList();
              result['orders'] = orders;
            } catch (e) {
              print('Error parsing orders: $e');
              // Return empty orders list but don't throw exception
            }
            
            // Add pagination data if available
            if (data['totalAmount'] != null) {
              result['totalAmount'] = data['totalAmount'];
            }
            if (data['totalPages'] != null) {
              result['totalPages'] = data['totalPages'];
            }
            if (data['totalElements'] != null) {
              result['totalElements'] = data['totalElements'];
            }
            if (data['currentPage'] != null) {
              result['currentPage'] = data['currentPage'];
            }
            if (data['pageSize'] != null) {
              result['pageSize'] = data['pageSize'];
            }
          }
        }
      }
      
      return result;
    } catch (e) {
      print('Error fetching orders: $e');
      // Return a default result instead of throwing an exception
      return {
        'orders': <Order>[],
        'message': 'Error: ${e.toString()}',
        'totalAmount': 0,
        'totalPages': 0,
        'totalElements': 0,
        'currentPage': 0,
        'pageSize': size,
        'error': true,
      };
    }
  }

  /// Delete an order by ID
  /// 
  /// This method doesn't rely on context, so it's safe to use even if the widget tree changes
  Future<Map<String, dynamic>> deleteOrder(String id) async {
    try {
      // First check if the ID is valid
      if (id.isEmpty) {
        return {
          'success': false,
          'message': 'ID đơn hàng không hợp lệ',
        };
      }
      
      final response = await _apiClient.remove('/orders', id);
      
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Đã xóa đơn hàng thành công',
        };
      } else if (response.data != null && response.data is Map<String, dynamic>) {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Không thể xóa đơn hàng',
        };
      } else {
        return {
          'success': false,
          'message': 'Không thể xóa đơn hàng (${response.statusCode})',
        };
      }
    } catch (e) {
      print('Error deleting order: $e');
      return {
        'success': false,
        'message': 'Lỗi: ${e.toString()}',
      };
    }
  }
}
