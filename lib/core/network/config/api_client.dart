import 'dart:convert';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.117:8080/api/v1',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  ApiClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Thêm token vào header
        options.headers["Authorization"] = "Bearer Huy";
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Xử lý lỗi API
        String errorDescription = "";
        switch (e.type) {
          case DioExceptionType.cancel:
            errorDescription = "Request to API server was cancelled";
            break;
          case DioExceptionType.connectionTimeout:
            errorDescription = "Connection timeout with API server";
            break;
          case DioExceptionType.receiveTimeout:
            errorDescription = "Receive timeout in connection with API server";
            break;
          case DioExceptionType.sendTimeout:
            errorDescription = "Send timeout in connection with API server";
            break;
          case DioExceptionType.unknown:
            errorDescription =
                "Connection to API server failed due to internet connection";
            break;
          case DioExceptionType.badCertificate:
            errorDescription = "Bad certificate";
            break;
          case DioExceptionType.badResponse:
            errorDescription = "Bad response";
            break;
          case DioExceptionType.connectionError:
            errorDescription = "Connection error";
            break;
        }
        print("API Error: $errorDescription");
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      print('Error: $e');
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

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: jsonEncode(data));
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: jsonEncode(data));
  }

  Future<Response> delete(String path, String id) async {
    return await _dio.delete('$path/$id');
  }
}
