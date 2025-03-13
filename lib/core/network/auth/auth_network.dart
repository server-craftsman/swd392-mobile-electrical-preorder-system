import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import 'package:dio/dio.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';

class AuthNetwork {
  final ApiClient _apiClient = ApiClient();

  Future<String?> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,

          // 'googleAccountId': googleAccountId,
          // 'fullName': fullName,
        },
      );

      if (response.data != null && response.data is Map<String, dynamic>) {
        final accessToken = response.data['accessToken'];
        if (accessToken is String) {
          await TokenService.saveAccessToken(accessToken);
          return accessToken;
        } else {
          print('Login failed: accessToken is not a string');
        }
      } else {
        print('Login failed: Invalid response format');
        print('Response data: ${response.data}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error during login: ${e.response?.data}');
        if (e.response?.statusCode == 403) {
          print(
            'Login failed: Access forbidden. Please check your credentials.',
          );
        }
      } else {
        print('Error during login: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error during login: $e');
    }
    return null;
  }

  Future<String?> socialLogin() async {
    try {
      final response = await _apiClient.get(
        '/auth/social-login?login_type=google',
      );

      if (response.data != null && response.data is String) {
        return response.data as String;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 403) {
        print('Social login failed: Access forbidden.');
      } else {
        print('Error during social login: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error during social login: $e');
    }
    return null;
  }
}
