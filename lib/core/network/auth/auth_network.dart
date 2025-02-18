import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';

class AuthNetwork {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await _apiClient.post(
      'auth/login',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>?;
  }
}
