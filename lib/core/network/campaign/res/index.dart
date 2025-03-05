import '../../product/res/index.dart';
import '../../page_info/res/index.dart';

class CampaignResponse {
  final String message;
  final CampaignData data;

  CampaignResponse({required this.message, required this.data});

  factory CampaignResponse.fromJson(Map<String, dynamic> json) {
    return CampaignResponse(
      message: json['message'],
      data: CampaignData.fromJson(json['data']),
    );
  }
}

class CampaignData {
  final List<Campaign> content;
  final PageInfo page;

  CampaignData({required this.content, required this.page});

  factory CampaignData.fromJson(Map<String, dynamic> json) {
    return CampaignData(
      content:
          (json['content'] as List)
              .map((item) => Campaign.fromJson(item))
              .toList(),
      page: PageInfo.fromJson(json['page']),
    );
  }
}

class Campaign {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int minQuantity;
  final int maxQuantity;
  final double totalAmount;
  final String status;
  final Product product;
  final DateTime createdAt;
  final DateTime updatedAt;

  Campaign({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.minQuantity,
    required this.maxQuantity,
    required this.totalAmount,
    required this.status,
    required this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      minQuantity: json['minQuantity'],
      maxQuantity: json['maxQuantity'],
      totalAmount: json['totalAmount'],
      status: json['status'],
      product: Product.fromJson(json['product']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
