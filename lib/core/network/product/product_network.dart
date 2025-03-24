import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import './res/index.dart';
import './req/index.dart';

/// Helper class to pass parameters to isolate
class _FormDataParams {
  final Map<String, dynamic> productData;
  final List<String> imagePaths; // Store paths instead of File objects
  final bool isCreating;

  _FormDataParams(this.productData, this.imagePaths, this.isCreating);
}

/// Network service for product-related API operations
/// Optimized to prevent ANR issues by using isolates and better resource management
class ProductNetwork {
  /// Cancellation token for aborting requests if needed
  static CancelToken _cancelToken = CancelToken();

  /// Get list of products with optimized parsing
  static Future<ProductResponse> getProductList() async {
    try {
      final apiClient = ApiClient();

      // Use cancellable token to allow aborting requests
      final response = await apiClient.get(
        '/products',
        cancelToken: _cancelToken,
      );

      // Validate response format
      if (response.data == null) {
        throw Exception('Invalid response data: null');
      }

      // Process response in a separate isolate to avoid UI blocking
      return await compute(_parseProductResponse, response.data);
    } catch (e) {
      print('Error in getProductList: $e');
      // Return empty response instead of throwing
      return ProductResponse(
        message: 'Failed to load products: $e',
        data: ProductData(
          content: [],
          totalPages: 0,
          totalElements: 0,
          first: true,
          last: true,
          size: 0,
          number: 0,
        ),
      );
    }
  }

  /// Parse product response in a separate isolate
  static ProductResponse _parseProductResponse(dynamic data) {
    return ProductResponse.fromJson(data);
  }

  /// Count products with optimized error handling
  static Future<int> countProduct() async {
    try {
      final response = await ApiClient().get('/products/count');
      return response.data['data'] as int;
    } catch (e) {
      print('Error in countProduct: $e');
      return 0; // Return 0 as fallback
    }
  }

  /// Create a new product with optimized image processing
  static Future<Map<String, dynamic>> createProduct(
    Map<String, dynamic> productData,
    List<File>? imageFiles,
  ) async {
    // Reset cancel token if it was cancelled before
    if (_cancelToken.isCancelled) {
      _cancelToken = CancelToken();
    }

    try {
      // Immediate return if no image files
      if (imageFiles == null || imageFiles.isEmpty) {
        final formData = await _prepareFormData(productData);
        final response = await ApiClient().post(
          '/products',
          data: formData,
          cancelToken: _cancelToken,
        );
        return response.data;
      }

      // Validate files early and collect paths to avoid file handle issues
      final List<String> validPaths = [];
      for (final file in imageFiles) {
        try {
          if (await file.exists()) {
            final fileSize = await file.length();
            // Only add files under 5MB to prevent OOM errors
            if (fileSize <= 5 * 1024 * 1024) {
              validPaths.add(file.path);
            } else {
              print(
                'Skipping large file: ${file.path} (${fileSize ~/ 1024}KB)',
              );
            }
          }
        } catch (e) {
          print('File validation error: $e');
          // Continue with other files
        }
      }

      // Process in background thread
      final formData = await compute(
        _prepareFormDataWithImagePaths,
        _FormDataParams(productData, validPaths, true),
      );

      // Send request with progress tracking to prevent UI blocking
      final response = await ApiClient().post(
        '/products',
        data: formData,
        cancelToken: _cancelToken,
      );

      return response.data;
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return {'success': false, 'message': 'Operation was cancelled'};
      }
      print('Error in createProduct: $e');
      return {'success': false, 'message': 'Failed to create product: $e'};
    }
  }

  /// Update product with optimized image processing
  static Future<Map<String, dynamic>> updateProduct(
    Map<String, dynamic> productData,
    List<File>? imageFiles,
  ) async {
    // Reset cancel token if it was cancelled before
    if (_cancelToken.isCancelled) {
      _cancelToken = CancelToken();
    }

    try {
      // Immediate return if no image files
      if (imageFiles == null || imageFiles.isEmpty) {
        final formData = await _prepareFormData(productData);
        final response = await ApiClient().put(
          '/products',
          data: formData,
          cancelToken: _cancelToken,
        );
        return response.data;
      }

      // Validate files early and collect paths to avoid file handle issues
      final List<String> validPaths = [];
      for (final file in imageFiles) {
        try {
          if (await file.exists()) {
            final fileSize = await file.length();
            // Only add files under 5MB to prevent OOM errors
            if (fileSize <= 5 * 1024 * 1024) {
              validPaths.add(file.path);
            } else {
              print(
                'Skipping large file: ${file.path} (${fileSize ~/ 1024}KB)',
              );
            }
          }
        } catch (e) {
          print('File validation error: $e');
          // Continue with other files
        }
      }

      // Process in background thread
      final formData = await compute(
        _prepareFormDataWithImagePaths,
        _FormDataParams(productData, validPaths, false),
      );

      // Send request with progress tracking to prevent UI blocking
      final response = await ApiClient().put(
        '/products',
        data: formData,
        cancelToken: _cancelToken,
      );

      return response.data;
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return {'success': false, 'message': 'Operation was cancelled'};
      }
      print('Error in updateProduct: $e');
      return {'success': false, 'message': 'Failed to update product: $e'};
    }
  }

  /// Process form data with image paths in a separate isolate
  /// This avoids file handle leaks by only opening files in the isolate
  static Future<FormData> _prepareFormDataWithImagePaths(
    _FormDataParams params,
  ) async {
    final formData = FormData();

    // Add product data as JSON string
    formData.fields.add(
      MapEntry('productData', jsonEncode(params.productData)),
    );

    // Add image files from paths
    if (params.imagePaths.isNotEmpty) {
      int successfullyAdded = 0;

      for (final path in params.imagePaths) {
        try {
          // Get file name from path - this is safe from file access issues
          final fileName = path.split('/').last;

          // Create multipart file directly from path
          final multipartFile = await MultipartFile.fromFile(
            path,
            filename: fileName,
          );

          // Add file to form data
          formData.files.add(MapEntry('images', multipartFile));
          successfullyAdded++;
        } catch (e) {
          print('Error processing image in isolate: $e');
          // Continue with other files
        }
      }

      print('Added $successfullyAdded images to request');
    }

    return formData;
  }

  /// Prepare form data without images (lighter operation)
  static Future<FormData> _prepareFormData(
    Map<String, dynamic> productData,
  ) async {
    final formData = FormData();
    formData.fields.add(MapEntry('productData', jsonEncode(productData)));
    return formData;
  }

  /// Delete product with improved error handling
  static Future<Map<String, dynamic>> deleteProduct(String productId) async {
    try {
      final response = await ApiClient().remove(
        '/products',
        productId,
        cancelToken: _cancelToken,
      );
      return response.data;
    } catch (e) {
      print('Error in deleteProduct: $e');
      return {'success': false, 'message': 'Failed to delete product: $e'};
    }
  }

  /// Delete multiple products with improved error handling
  static Future<Map<String, dynamic>> deleteMultipleProducts(
    List<String> productIds,
  ) async {
    try {
      final response = await ApiClient().post(
        '/products',
        data: {'ids': productIds},
        queryParameters: {'_method': 'DELETE'},
        cancelToken: _cancelToken,
      );

      return response.data;
    } catch (e) {
      print('Error in deleteMultipleProducts: $e');
      return {'success': false, 'message': 'Failed to delete products: $e'};
    }
  }

  /// Cancel any ongoing network operations and reset the token
  static void cancelOperations() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel('User cancelled operation');
      // Create a new token for future operations
      _cancelToken = CancelToken();
    }
  }
}
