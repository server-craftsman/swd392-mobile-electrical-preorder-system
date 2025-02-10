import 'dart:convert';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  ApiClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Thêm token vào header
        options.headers["Authorization"] = "Bearer YOUR_ACCESS_TOKEN";
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        // Xử lý lỗi API
        print("API Error: ${e.response?.statusCode}");
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return await _dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: jsonEncode(data));
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: jsonEncode(data));
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
