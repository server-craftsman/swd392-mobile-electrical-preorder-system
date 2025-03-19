import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/req/user_req.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/register_res.dart';
import 'package:mobile_electrical_preorder_system/core/utils/format_response.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/index.dart';

class UserNetwork {
  final ApiClient _apiClient = ApiClient();

  Future<FormatResponse<RegisterResponse>> register(
    RegisterRequest request,
  ) async {
    final response = await _apiClient.post('/user/sign-up', data: request);
    return FormatResponse(
      message: true,
      data: RegisterResponse.fromJson(response.data),
    );
  }

  Future<User?> getUserById(String userId) async {
    try {
      final response = await _apiClient.get('/users/$userId');
      return User.fromJson(response.data);
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getAllUser({int page = 0, int size = 10}) async {
    try {
      final response = await _apiClient.get(
        '/users',
        queryParameters: {'page': page, 'size': size},
      );

      // Extract data from response
      final responseData = response.data;

      // Check if the response has the expected structure
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data') &&
          responseData['data'] is Map<String, dynamic>) {
        final data = responseData['data'] as Map<String, dynamic>;

        // Parse users from response
        final List<User> users = [];
        if (data.containsKey('users') && data['users'] is List) {
          for (var userJson in data['users']) {
            try {
              users.add(User.fromJson(userJson));
            } catch (e) {
              print('Error parsing user: $e');
            }
          }
        }

        // Return structured data
        return {
          'users': users,
          'totalPages': data['totalPages'] ?? 0,
          'totalElements': data['totalElements'] ?? 0,
          'currentPage': data['currentPage'] ?? 0,
          'pageSize': data['pageSize'] ?? 10,
          'message': responseData['message'] ?? 'Users retrieved successfully',
        };
      }

      // Return empty result if response format is unexpected
      return {
        'users': <User>[],
        'totalPages': 0,
        'totalElements': 0,
        'currentPage': 0,
        'pageSize': 10,
        'message': 'Invalid response format',
      };
    } catch (e) {
      print('Error fetching all users: $e');

      // Return error result
      return {
        'users': <User>[],
        'totalPages': 0,
        'totalElements': 0,
        'currentPage': 0,
        'pageSize': 10,
        'message': 'Failed to fetch users: ${e.toString()}',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      // Make the DELETE request to the API
      final response = await _apiClient.remove('/users', userId);

      // Check if response was successful
      if (response.statusCode == 200 || response.statusCode == 204) {
        return {'success': true, 'message': 'Tài khoản đã được xóa thành công'};
      } else {
        // Handle different status codes if needed
        return {
          'success': false,
          'message': 'Không thể xóa tài khoản. Mã lỗi: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error deleting user: $e');
      return {
        'success': false,
        'message': 'Có lỗi xảy ra khi xóa tài khoản: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> signUpStaff({
    required String username,
    required String password,
    required String fullname,
    required String email,
    String phoneNumber = '',
    String address = '',
  }) async {
    try {
      // Structure the request data according to API expectations
      final data = {
        "username": username,
        "password": password,
        "fullname": fullname,
        "email": email,
        "phoneNumber": phoneNumber,
        "address": address,
        "role": "ROLE_STAFF",
        "status": "ACTIVE",
      };

      // Use a try-catch specifically for the API call
      try {
        // Change endpoint to match the correct API endpoint for staff registration
        final response = await _apiClient.post('/users/sign-up', data: data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = response.data;

          // Handle successful response
          if (responseData is Map<String, dynamic> &&
              responseData.containsKey('data')) {
            final userData = responseData['data'];
            final message =
                responseData['message'] ??
                'Tài khoản nhân viên đã được tạo thành công';

            return {'success': true, 'message': message, 'userData': userData};
          } else {
            return {
              'success': true,
              'message': 'Tài khoản nhân viên đã được tạo thành công',
              'userData': responseData,
            };
          }
        } else {
          // This block will likely not be reached due to Dio's default behavior
          return {
            'success': false,
            'message':
                'Không thể tạo tài khoản nhân viên. Mã lỗi: ${response.statusCode}',
          };
        }
      } catch (apiError) {
        // Extract error details from the Dio error response
        print('API Error: $apiError');

        // Check if the error contains response data
        String errorMessage = 'Có lỗi xảy ra khi tạo tài khoản nhân viên';

        // Try to extract detailed error message from the response
        if (apiError.toString().contains('DioException') &&
            apiError.toString().contains('response')) {
          try {
            // Attempt to extract the response data from Dio error
            final errorResponse = (apiError as dynamic).response?.data;
            if (errorResponse != null &&
                errorResponse is Map<String, dynamic>) {
              // If the API returns error details in a specific format
              if (errorResponse.containsKey('message')) {
                errorMessage = errorResponse['message'];
              } else if (errorResponse.containsKey('error')) {
                errorMessage = errorResponse['error'];
              }
            }
          } catch (e) {
            print('Error parsing error response: $e');
          }
        }

        // Common error cases based on status codes
        if (apiError.toString().contains('400')) {
          if (!errorMessage.contains('tồn tại')) {
            errorMessage = 'Dữ liệu không hợp lệ hoặc tài khoản đã tồn tại';
          }
        } else if (apiError.toString().contains('403')) {
          errorMessage = 'Không có quyền tạo tài khoản nhân viên';
        } else if (apiError.toString().contains('500')) {
          errorMessage = 'Lỗi máy chủ, vui lòng thử lại sau';
        }

        return {
          'success': false,
          'message': errorMessage,
          'error': apiError.toString(),
        };
      }
    } catch (e) {
      print('General error creating staff account: $e');
      return {
        'success': false,
        'message': 'Có lỗi xảy ra khi tạo tài khoản nhân viên: ${e.toString()}',
        'error': e.toString(),
      };
    }
  }
}
