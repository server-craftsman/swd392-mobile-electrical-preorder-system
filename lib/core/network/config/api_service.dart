import 'package:dio/dio.dart';
import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';

abstract class ApiService {
  final ApiClient _apiClient;

  ApiService(this._apiClient);

  Future<Response> get(String path) {
    return _apiClient.get(path);
  }

  Future<Response> getById(String path, String id) {
    return _apiClient.getById(path, id);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _apiClient.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _apiClient.put(path, data: data);
  }

  Future<Response> delete(String path, String id) {
    return _apiClient.remove(path, id);
  }
}
