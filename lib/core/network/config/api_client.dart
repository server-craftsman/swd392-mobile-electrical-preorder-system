import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';

/// Optimized ApiClient with reduced logging and better thread management
/// to prevent ANR issues and surface rendering problems
class ApiClient {
  late Dio _dio;
  static final ApiClient _instance = ApiClient._internal();

  // Additional flags to control thread-heavy operations
  static bool _detailedLogging =
      false; // Set to false by default to reduce processing
  static const int _defaultTimeout = 8; // Further reduced timeouts

  // Cancelable token for all API requests
  final CancelToken _globalCancelToken = CancelToken();

  // Track if we're performing a file upload operation
  bool _isUploadingFiles = false;

  // Factory constructor for singleton pattern
  factory ApiClient() {
    return _instance;
  }

  // Private constructor
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://elecee.azurewebsites.net/api/v1',
        connectTimeout: Duration(seconds: _defaultTimeout),
        receiveTimeout: Duration(seconds: _defaultTimeout),
        sendTimeout: Duration(seconds: _defaultTimeout),
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.json,
        // Enable HTTP persistent connection to reuse TCP connections
        extra: {'keep-alive': true},
      ),
    );

    // Add a lighter interceptor that doesn't block the main thread
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Minimal token handling - avoid heavy operations
          try {
            final token = await TokenService.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            // For multipart requests, let Dio handle content-type
            if (options.data is FormData) {
              options.contentType = 'multipart/form-data';

              // Mark that we're uploading files
              _isUploadingFiles = true;

              // Ensure that the request is not too large
              final formData = options.data as FormData;
              int totalSize = 0;

              // Estimate size of form data
              for (var file in formData.files) {
                if (file.value is MultipartFile) {
                  final multipartFile = file.value as MultipartFile;
                  totalSize += multipartFile.length;
                }
              }

              // If request is too large, log warning
              if (totalSize > 10 * 1024 * 1024) {
                print(
                  'Warning: Large request detected (${totalSize ~/ (1024 * 1024)}MB)',
                );
              }
            }
          } catch (e) {
            print('Auth error: $e');
          }

          // Continue with request immediately
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Reset upload flag on error
          _isUploadingFiles = false;

          // Minimal error handling to prevent thread blocking
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            print('API timeout on ${error.requestOptions.path}');
          } else if (error.response?.statusCode != null) {
            print(
              'API error ${error.response?.statusCode} on ${error.requestOptions.path}',
            );
          }

          return handler.next(error);
        },
        onResponse: (response, handler) {
          // Reset upload flag on success
          _isUploadingFiles = false;

          // Very lightweight response handling
          if (_detailedLogging) {
            print(
              'API Success: ${response.statusCode} for ${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },
      ),
    );

    // Add a lightweight retry interceptor
    _dio.interceptors.add(
      LightRetryInterceptor(
        dio: _dio,
        maxRetries: 1, // Reduced retries
      ),
    );
  }

  /// Cancels all ongoing requests
  void cancelAllRequests([String? reason]) {
    if (!_globalCancelToken.isCancelled) {
      _globalCancelToken.cancel(reason ?? 'Request cancelled by user');
    }
    // Reset upload flag
    _isUploadingFiles = false;
  }

  /// Check if a file upload is in progress
  bool get isUploadingFiles => _isUploadingFiles;

  /// Enable or disable detailed logging - should be off in production
  static void setDetailedLogging(bool enabled) {
    _detailedLogging = enabled;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final effectiveCancelToken = cancelToken ?? _globalCancelToken;

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: effectiveCancelToken,
        options: Options(
          // Force timeout even shorter for GET requests
          sendTimeout: Duration(seconds: 8),
          receiveTimeout: Duration(seconds: 8),
        ),
      );
      return response;
    } catch (e) {
      if (_detailedLogging) print('GET request error: $e');
      rethrow;
    }
  }

  Future<Response> getById(
    String path,
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final effectiveCancelToken = cancelToken ?? _globalCancelToken;

      return await _dio.get(
        '$path/$id',
        cancelToken: effectiveCancelToken,
        options: Options(
          sendTimeout: Duration(seconds: 8),
          receiveTimeout: Duration(seconds: 8),
        ),
      );
    } catch (e) {
      if (_detailedLogging) print('GET by ID error: $e');
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final effectiveCancelToken = cancelToken ?? _globalCancelToken;

      // Determine if this is a multipart request
      final bool isMultipart = data is FormData;

      // Set options based on request type
      final options = Options(
        contentType: isMultipart ? 'multipart/form-data' : 'application/json',
        // Adjust timeout for different request types
        sendTimeout:
            isMultipart
                ? Duration(seconds: 30)
                : Duration(seconds: _defaultTimeout),
        receiveTimeout: Duration(seconds: _defaultTimeout),
      );

      // For multipart requests, use background processing if possible
      if (isMultipart && data is FormData) {
        // Process in the background if possible
        Stopwatch timer = Stopwatch()..start();

        final response = await _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: effectiveCancelToken,
        );

        timer.stop();
        print('Upload completed in ${timer.elapsedMilliseconds}ms');

        return response;
      } else {
        // Regular request
        return await _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: effectiveCancelToken,
        );
      }
    } catch (e) {
      _isUploadingFiles = false;
      if (_detailedLogging) print('POST request error: $e');
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final effectiveCancelToken = cancelToken ?? _globalCancelToken;

      // Check if this is a multipart request (FormData)
      final bool isMultipart = data is FormData;

      final options = Options(
        contentType: isMultipart ? 'multipart/form-data' : 'application/json',
        // Adjust timeout for multipart requests
        sendTimeout:
            isMultipart
                ? Duration(seconds: 30)
                : Duration(seconds: _defaultTimeout),
      );

      // For multipart requests, use safer encoding
      if (isMultipart) {
        return await _dio.put(
          path,
          data: data,
          options: options,
          cancelToken: effectiveCancelToken,
        );
      } else {
        final encodedData = jsonEncode(data);
        return await _dio.put(
          path,
          data: encodedData,
          options: options,
          cancelToken: effectiveCancelToken,
        );
      }
    } catch (e) {
      _isUploadingFiles = false;
      if (_detailedLogging) print('PUT request error: $e');
      rethrow;
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final effectiveCancelToken = cancelToken ?? _globalCancelToken;

      // Check if this is a multipart request (FormData)
      final bool isMultipart = data is FormData;

      final options = Options(
        contentType: isMultipart ? 'multipart/form-data' : 'application/json',
        // Adjust timeout for multipart requests
        sendTimeout:
            isMultipart
                ? Duration(seconds: 30)
                : Duration(seconds: _defaultTimeout),
      );

      final encodedData = isMultipart ? data : jsonEncode(data);

      return await _dio.patch(
        path,
        data: encodedData,
        options: options,
        cancelToken: effectiveCancelToken,
      );
    } catch (e) {
      if (_detailedLogging) print('PATCH request error: $e');
      rethrow;
    }
  }

  Future<Response> remove(
    String path,
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final effectiveCancelToken = cancelToken ?? _globalCancelToken;

      return await _dio.delete('$path/$id', cancelToken: effectiveCancelToken);
    } catch (e) {
      if (_detailedLogging) print('DELETE request error: $e');
      rethrow;
    }
  }

  // Create a cancelable request token that can be used to cancel ongoing requests
  CancelToken createCancelToken() {
    return CancelToken();
  }
}

// Helper function for string manipulation
int min(int a, int b) => a < b ? a : b;

/// Lightweight retry interceptor that doesn't block the main thread
class LightRetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  LightRetryInterceptor({required this.dio, this.maxRetries = 1});

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    int retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    // Only retry on network errors, not application errors
    if (retryCount < maxRetries &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout)) {
      // Simple retry with minimal delay
      retryCount++;
      print('Quick retry #$retryCount for ${err.requestOptions.path}');

      // Simple backoff
      await Future.delayed(Duration(milliseconds: 250));

      try {
        final options = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          extra: {...err.requestOptions.extra, 'retryCount': retryCount},
        );

        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: options,
        );

        return handler.resolve(response);
      } catch (e) {
        return super.onError(
          e is DioException
              ? e
              : DioException(requestOptions: err.requestOptions, error: e),
          handler,
        );
      }
    }

    return super.onError(err, handler);
  }
}
