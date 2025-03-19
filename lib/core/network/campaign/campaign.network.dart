import 'package:flutter/foundation.dart';
import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import './res/index.dart';
import './req/index.dart';

class CampaignNetwork {
  static Future<CampaignResponse> getCampaignList({
    String? name,
    String? status,
  }) async {
    Map<String, dynamic> queryParams = {};

    if (name != null && name.isNotEmpty) {
      queryParams['name'] = name;
    }

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await ApiClient().get(
      '/campaigns',
      queryParameters: queryParams,
    );

    return CampaignResponse.fromJson(response.data);
  }

  static Future<CampaignResponse> getCampaignById(int campaignId) async {
    // Fix: Use get method instead of getById with the correct path format
    final response = await ApiClient().get('/campaigns/$campaignId');

    return CampaignResponse.fromJson(response.data);
  }

  // Add this method to your CampaignNetwork class
  static Future<void> createCampaign(CreateCampaignRequest request) async {
    try {
      print('Creating campaign with data: ${request.toJson()}');
      final response = await ApiClient().post(
        '/campaigns',
        data: request.toJson(),
      );
      print('Campaign created successfully: ${response.statusCode}');
    } catch (e) {
      print('Error in createCampaign API call: $e');

      // Rethrow to allow handling in the UI
      throw e;
    }
  }

  // Add this method to your CampaignNetwork class
  static Future<Null> cancelCampaign(int campaignId) async {
    // Fix: Check if the API client has a remove method, otherwise use delete
    await ApiClient().remove('/campaigns', campaignId.toString());
    return;
  }
}
