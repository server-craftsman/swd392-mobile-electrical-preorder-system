import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://elecee.azurewebsites.net/api/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    
    // Add interceptor to automatically add auth token to requests
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get the token and add it to the Authorization header if it exists
          final token = await TokenService.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print('Adding token to request: Bearer ${token.substring(0, min(10, token.length))}...');
          } else {
            print('No token available for request to ${options.path}');
          }
          
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          print('API Error: ${error.message}');
          print('Response data: ${error.response?.data}');
          if (error.response?.statusCode == 401 || error.response?.statusCode == 403) {
            print('Authentication error - token may be invalid or expired');
            // Handle token expiration or auth error
          }
          return handler.next(error);
        },
        onResponse: (response, handler) {
          print('API Response Status: ${response.statusCode}');
          return handler.next(response);
        },
      ),
    );
  }

  //==========================================================================

  // Methods

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      print('GET request error: $e');
      rethrow;
    }
  }

  Future<Response> getById(String path, String id) async {
    try {
      return await _dio.get('$path/$id');
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      print('POST request error: $e');
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: jsonEncode(data));
  }

  Future<Response> remove(String path, String id) async {
    try {
      return await _dio.delete('$path/$id');
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}

// Helper function for string manipulation
int min(int a, int b) => a < b ? a : b;
