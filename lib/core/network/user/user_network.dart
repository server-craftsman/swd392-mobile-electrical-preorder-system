import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/req/user_req.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/register_res.dart';
import 'package:mobile_electrical_preorder_system/core/utils/format_response.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/index.dart';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';

class UserNetwork {
  final ApiClient _apiClient = ApiClient();
  CancelToken _cancelToken = CancelToken();

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

  /// Update user profile with avatar image support
  /// This method optimizes file handling to prevent ANR errors
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> userData,
    File? avatarImage,
  }) async {
    try {
      // Validate userId
      if (userId.isEmpty) {
        return {'success': false, 'message': 'ID người dùng không hợp lệ'};
      }

      // Reset cancel token if needed
      if (_cancelToken.isCancelled) {
        _cancelToken = CancelToken();
      }

      // Log request details for debugging
      print('Updating user profile for userId: $userId');
      print('Request data: ${json.encode(userData)}');
      print('Image included: ${avatarImage != null}');

      // Sanitize and validate user data
      final formattedData = _sanitizeUserData(userData);
      if (!_validateUserData(formattedData)) {
        return {
          'success': false,
          'message': 'Dữ liệu không hợp lệ. Vui lòng kiểm tra tên hiển thị.',
        };
      }

      // If no avatar image, send regular JSON request
      if (avatarImage == null) {
        // JSON request handling remains unchanged
        print('Sending JSON request with data: ${json.encode(formattedData)}');

        // Format data to match the updateUserRequest structure
        final updateUserRequest = {
          'fullname': formattedData['fullname'] ?? '',
          'phoneNumber': formattedData['phoneNumber'] ?? '',
          'address': formattedData['address'] ?? '',
        };

        // ApiClient.put method handles JSON with proper content type
        final response = await _apiClient.put(
          '/users/$userId',
          data: updateUserRequest,
          cancelToken: _cancelToken,
        );
        return _processUpdateResponse(response);
      }

      // Handle avatar upload with the direct upload method
      if (avatarImage != null) {
        // Validate file early
        bool isValidFile = await _validateImageFile(avatarImage);
        if (!isValidFile) {
          return {
            'success': false,
            'message': 'Ảnh đại diện không hợp lệ hoặc quá lớn (giới hạn 3MB)',
          };
        }

        print('Avatar validation passed, using direct upload method');

        // Use direct upload method for more control over multipart form data
        return await _directAvatarUpload(userId, formattedData, avatarImage);
      }

      // Fallback error - should never reach here
      return {
        'success': false,
        'message': 'Lỗi không xác định khi cập nhật thông tin người dùng',
      };
    } catch (e) {
      print('Error updating user profile: $e');

      // Handle specific DioExceptions more gracefully
      if (e is DioException) {
        final dioError = e as DioException;

        if (dioError.type == DioExceptionType.cancel) {
          return {'success': false, 'message': 'Cập nhật bị hủy'};
        }

        // Server error (500)
        if (dioError.response?.statusCode == 500) {
          print(
            'Server returned 500 error. Response: ${dioError.response?.data}',
          );
          String serverMessage = 'Không có thông tin lỗi';
          try {
            if (dioError.response?.data != null) {
              if (dioError.response?.data is Map) {
                final errorData = dioError.response?.data as Map;
                serverMessage = errorData['message'] ?? serverMessage;
              } else if (dioError.response?.data is String) {
                serverMessage =
                    dioError.response?.data.toString() ?? serverMessage;
              }
            }
          } catch (parseError) {
            print('Error parsing server response: $parseError');
          }

          return {
            'success': false,
            'message': 'Lỗi máy chủ, vui lòng thử lại sau',
            'errorCode': 500,
            'serverMessage': serverMessage,
          };
        }

        // Connection timeout
        if (dioError.type == DioExceptionType.connectionTimeout ||
            dioError.type == DioExceptionType.receiveTimeout ||
            dioError.type == DioExceptionType.sendTimeout) {
          return {
            'success': false,
            'message':
                'Quá thời gian kết nối, kiểm tra kết nối mạng và thử lại',
          };
        }

        // Bad request (400)
        if (dioError.response?.statusCode == 400) {
          String errorMsg = 'Dữ liệu gửi lên không hợp lệ';
          try {
            if (dioError.response?.data is Map) {
              final errorData = dioError.response?.data as Map;
              errorMsg = errorData['message'] ?? errorMsg;
            }
          } catch (parseError) {
            print('Error parsing 400 response: $parseError');
          }
          return {'success': false, 'message': errorMsg};
        }

        // Get response message if available
        String errorMsg = 'Lỗi cập nhật thông tin';
        if (dioError.response?.data is Map) {
          final errorData = dioError.response?.data as Map;
          errorMsg = errorData['message'] ?? errorMsg;
        }

        return {'success': false, 'message': errorMsg};
      }

      return {
        'success': false,
        'message': 'Lỗi cập nhật thông tin: ${e.toString().split('\n')[0]}',
      };
    }
  }

  // Helper method to sanitize user data before sending to API
  Map<String, dynamic> _sanitizeUserData(Map<String, dynamic> userData) {
    final sanitized = Map<String, dynamic>.from(userData);

    // Remove null values
    sanitized.removeWhere((key, value) => value == null);

    // Ensure strings aren't empty for required fields
    ['fullname', 'phoneNumber'].forEach((field) {
      if (sanitized.containsKey(field) &&
          (sanitized[field] == null ||
              sanitized[field].toString().trim().isEmpty)) {
        sanitized.remove(field);
      }
    });

    return sanitized;
  }

  // Process response from update user API
  Map<String, dynamic> _processUpdateResponse(Response response) {
    try {
      print('Update response status: ${response.statusCode}');
      print(
        'Update response body: ${response.data != null ? response.data : "No content"}',
      );

      // For 204 No Content responses - this is a success status with no body
      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Cập nhật thành công',
          'data': null,
        };
      }

      // For 200 OK or 201 Created responses with body
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final message = data['message'] ?? 'Cập nhật thành công';
          final success = data.containsKey('success') ? data['success'] : true;
          return {'success': success, 'message': message, 'data': data['data']};
        }
        return {
          'success': true,
          'message': 'Cập nhật thành công',
          'data': data,
        };
      }

      // For other status codes
      return {
        'success': false,
        'message': 'Cập nhật thất bại với mã lỗi: ${response.statusCode}',
      };
    } catch (e) {
      print('Error processing update response: $e');
      return {'success': false, 'message': 'Lỗi xử lý phản hồi: $e'};
    }
  }

  // Validate image file in background thread
  Future<bool> _validateImageFile(File file) async {
    try {
      if (await file.exists()) {
        final fileSize = await file.length();
        // Limit file size to 3MB
        return fileSize <= 3 * 1024 * 1024;
      }
      return false;
    } catch (e) {
      print('Error validating image file: $e');
      return false;
    }
  }

  // Validate important user data fields
  bool _validateUserData(Map<String, dynamic> userData) {
    // Check for presence of required fields
    if (!userData.containsKey('fullname') ||
        userData['fullname'].toString().trim().isEmpty) {
      return false;
    }
    return true;
  }

  // Cancel any ongoing operations
  void cancelOperations() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel('User cancelled operation');
    }
  }

  Future<Map<String, dynamic>> getAllUser({
    int page = 0,
    int size = 10,
    String? role,
  }) async {
    try {
      // Create query parameters map
      final Map<String, dynamic> queryParams = {'page': page, 'size': size};

      // Add role parameter if provided
      if (role != null) {
        queryParams['role'] = role;
      }

      final response = await _apiClient.get(
        '/users',
        queryParameters: queryParams,
      );

      final responseData = response.data;

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data') &&
          responseData['data'] is Map<String, dynamic>) {
        final data = responseData['data'] as Map<String, dynamic>;

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

        return {
          'users': users,
          'totalPages': data['totalPages'] ?? 0,
          'totalElements': data['totalElements'] ?? 0,
          'currentPage': data['currentPage'] ?? 0,
          'pageSize': data['pageSize'] ?? 10,
          'message': responseData['message'] ?? 'Users retrieved successfully',
        };
      }

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

  // Direct Dio upload method for more control over the avatar upload process
  Future<Map<String, dynamic>> _directAvatarUpload(
    String userId,
    Map<String, dynamic> userData,
    File avatarFile,
  ) async {
    int retryCount = 0;
    const int maxRetries = 2;
    const Duration retryDelay = Duration(seconds: 2);

    Future<Response?> attemptUpload() async {
      try {
        // Create a direct Dio instance
        final dio = Dio(
          BaseOptions(
            baseUrl: 'https://elecee.azurewebsites.net/api/v1',
            connectTimeout: Duration(seconds: 30),
            receiveTimeout: Duration(seconds: 20),
            sendTimeout: Duration(seconds: 30),
          ),
        );

        // Get token to add to request
        final token = await TokenService.getAccessToken();

        // Prepare the request
        final formData = FormData();

        // Prepare JSON data
        final updateUserRequest = {
          'fullname': userData['fullname'] ?? '',
          'phoneNumber': userData['phoneNumber'] ?? '',
          'address': userData['address'] ?? '',
        };

        // Add JSON data as a field
        formData.fields.add(
          MapEntry('updateUserRequest', json.encode(updateUserRequest)),
        );

        // Get file info
        final fileName = avatarFile.path.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();

        // Determine content type
        String contentType = 'image/jpeg'; // Default
        if (extension == 'png') {
          contentType = 'image/png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          contentType = 'image/jpeg';
        } else if (extension == 'gif') {
          contentType = 'image/gif';
        } else if (extension == 'webp') {
          contentType = 'image/webp';
        }

        // Add avatar file with content type
        final multipartFile = await MultipartFile.fromFile(
          avatarFile.path,
          filename: fileName,
          contentType: MediaType.parse(contentType),
        );

        formData.files.add(MapEntry('avatar', multipartFile));

        // Log form data
        print('Direct upload form data prepared (attempt ${retryCount + 1}):');
        print('- Fields: ${formData.fields.map((f) => f.key).join(', ')}');
        print('- Files: ${formData.files.map((f) => f.key).join(', ')}');

        // Set headers with token
        final options = Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          contentType: 'multipart/form-data',
          sendTimeout: Duration(seconds: 30),
          // Don't follow redirects automatically - we'll handle them
          followRedirects: false,
          validateStatus: (status) {
            // Consider any status code valid so we can handle it ourselves
            return true;
          },
        );

        // Make the request
        final response = await dio.put(
          '/users/$userId',
          data: formData,
          options: options,
          cancelToken: _cancelToken,
          onSendProgress: (sent, total) {
            print(
              'Upload progress: ${(sent / total * 100).toStringAsFixed(1)}%',
            );
          },
        );

        return response;
      } catch (e) {
        print('Upload attempt ${retryCount + 1} failed: $e');
        return null;
      }
    }

    // Start upload attempts with retry
    while (retryCount <= maxRetries) {
      // Attempt upload
      final response = await attemptUpload();

      // If upload attempt completely failed (no response)
      if (response == null) {
        retryCount++;
        if (retryCount <= maxRetries) {
          print('Retrying upload in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
          continue;
        } else {
          return {
            'success': false,
            'message': 'Không thể tải lên ảnh sau nhiều lần thử',
          };
        }
      }

      // Process response
      print('Direct upload response status: ${response.statusCode}');
      print('Direct upload response data: ${response.data ?? "No content"}');

      // Success cases
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return _processUpdateResponse(response);
      }

      // Retry for server errors (5xx) and some client errors that might be transient
      if (response.statusCode != null &&
          (response.statusCode! >= 500 || response.statusCode == 429)) {
        retryCount++;
        if (retryCount <= maxRetries) {
          print(
            'Server error (${response.statusCode}), retrying upload in ${retryDelay.inSeconds} seconds...',
          );
          await Future.delayed(retryDelay);
          continue;
        }
      }

      // For other errors, don't retry
      return _handleUploadError(response);
    }

    // This should not be reached, but just in case
    return {
      'success': false,
      'message': 'Lỗi không xác định khi tải lên ảnh đại diện',
    };
  }

  // Helper to handle upload errors
  Map<String, dynamic> _handleUploadError(Response response) {
    // Handle specific status codes
    if (response.statusCode == 400) {
      return {
        'success': false,
        'message': 'Định dạng ảnh không hợp lệ hoặc dữ liệu không đúng',
        'errorCode': 400,
      };
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return {
        'success': false,
        'message': 'Bạn không có quyền thực hiện thao tác này',
        'errorCode': response.statusCode,
      };
    } else if (response.statusCode == 413) {
      return {
        'success': false,
        'message': 'Ảnh quá lớn, vui lòng chọn ảnh có kích thước nhỏ hơn',
        'errorCode': 413,
      };
    } else if (response.statusCode == 500) {
      return {
        'success': false,
        'message': 'Lỗi máy chủ, vui lòng thử lại sau',
        'errorCode': response.statusCode,
        'serverMessage': response.data?.toString() ?? 'Không có chi tiết lỗi',
      };
    }

    // Default error response
    return {
      'success': false,
      'message': 'Lỗi khi tải lên ảnh đại diện (${response.statusCode})',
      'errorCode': response.statusCode,
    };
  }

  // Add method to change user password
  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Validate inputs
      if (userId.isEmpty) {
        return {'success': false, 'message': 'ID người dùng không hợp lệ'};
      }

      if (currentPassword.isEmpty) {
        return {
          'success': false,
          'message': 'Mật khẩu hiện tại không được để trống',
        };
      }

      if (newPassword.isEmpty) {
        return {
          'success': false,
          'message': 'Mật khẩu mới không được để trống',
        };
      }

      // Create request data
      final data = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };

      // Make the API call to change password
      final response = await _apiClient.put(
        '/users/$userId/password',
        data: data,
      );

      // Process the response
      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Mật khẩu đã được thay đổi thành công',
        };
      } else {
        // This will likely not be reached due to Dio's default error handling
        return {
          'success': false,
          'message':
              'Không thể thay đổi mật khẩu. Mã lỗi: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error changing password: $e');

      // Handle specific error cases
      String errorMessage = 'Có lỗi xảy ra khi thay đổi mật khẩu';

      if (e is DioException) {
        final dioError = e;

        // Handle unauthorized (wrong current password)
        if (dioError.response?.statusCode == 401) {
          errorMessage = 'Mật khẩu hiện tại không chính xác';
        }
        // Handle bad request (validation errors)
        else if (dioError.response?.statusCode == 400) {
          errorMessage = 'Mật khẩu mới không hợp lệ';

          // Try to extract more specific error message from response
          if (dioError.response?.data is Map) {
            final errorData = dioError.response?.data as Map;
            if (errorData.containsKey('message')) {
              errorMessage = errorData['message'];
            }
          }
        }
        // Handle server errors
        else if (dioError.response?.statusCode == 500) {
          errorMessage = 'Lỗi máy chủ, vui lòng thử lại sau';
        }
      }

      return {'success': false, 'message': errorMessage};
    }
  }
}
