import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
// import 'package:dio/dio.dart';
// import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import './res/index.dart';
import './req/index.dart';

class CampaignNetwork {
  static Future<CampaignResponse> getCampaignList() async {
    final response = await ApiClient().get('/campaigns');

    return CampaignResponse.fromJson(response.data);
  }

  // Add this method to your CampaignNetwork class
  static Future<void> createCampaign(CreateCampaignRequest request) async {
    await ApiClient().post('/campaigns', data: request.toJson());
  }
}
