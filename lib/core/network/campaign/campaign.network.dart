import 'package:flutter/foundation.dart';
import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import './res/index.dart';
import './req/index.dart';

class SingleCampaignResponse {
  final Campaign campaign;

  SingleCampaignResponse({required this.campaign});

  factory SingleCampaignResponse.fromJson(Map<String, dynamic> json) {
    return SingleCampaignResponse(campaign: Campaign.fromJson(json['data']));
  }
}

class CampaignNetwork {
  static Future<CampaignResponse> getCampaignList({
    String? name,
    String? status,
    String? direction,
  }) async {
    Map<String, dynamic> queryParams = {};

    if (name != null && name.isNotEmpty) {
      queryParams['name'] = name;
    }

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    if (direction != null && direction.isNotEmpty) {
      queryParams['direction'] = direction;
    }

    final response = await ApiClient().get(
      '/campaigns',
      queryParameters: queryParams,
    );

    return CampaignResponse.fromJson(response.data);
  }

  static Future<SingleCampaignResponse> getCampaignById(
    String campaignId,
  ) async {
    try {
      final response = await ApiClient().get('/campaigns/$campaignId');

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      return SingleCampaignResponse.fromJson(response.data);
    } catch (e) {
      print('Error fetching campaign: $e');
      throw Exception('Failed to retrieve campaign: $e');
    }
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
  static Future<void> cancelCampaign(String campaignId) async {
    try {
      await ApiClient().remove('/campaigns', campaignId);
      print('Campaign cancelled successfully: $campaignId');
    } catch (e) {
      print('Error cancelling campaign: $e');
      throw Exception('Failed to cancel campaign: $e');
    }
  }

  // Add this method to your CampaignNetwork class
  static Future<void> updateCampaign(UpdateCampaignRequest request) async {
    try {
      print('Updating campaign with data: ${request.toJson()}');
      final response = await ApiClient().put(
        '/campaigns/${request.id}',
        data: request.toJson(),
      );
      print('Campaign updated successfully: ${response.statusCode}');
    } catch (e) {
      print('Error in updateCampaign API call: $e');

      // Rethrow to allow handling in the UI
      throw e;
    }
  }
}
