import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';

class AuthNetwork {
  final ApiClient _apiClient = ApiClient();

  Future<String?> login(
    String username,
    String password, {
    String? googleAccountId,
    String? fullName,
  }) async {
    final response = await _apiClient.post(
      'auth/login',
      data: {
        'username': username,
        'password': password,
        'googleAccountId': googleAccountId,
        'fullName': fullName,
      },
    );
    return response.data['accessToken'] as String?;
  }

  Future<String?> socialLogin() async {
    final response = await _apiClient.get(
      'auth/social-login?login_type=google',
    );

    if (response.data != null && response.data is String) {
      return response.data as String;
    }
    return null;
  }
}
