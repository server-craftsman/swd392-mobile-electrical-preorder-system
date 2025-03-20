class CreateCampaignRequest {
  final String name;
  final String startDate;
  final String endDate;
  final int minQuantity;
  final int maxQuantity;
  final double totalAmount;
  final String? status;
  final String productId;

  CreateCampaignRequest({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.minQuantity,
    required this.maxQuantity,
    required this.totalAmount,
    this.status,
    required this.productId,
  });

  factory CreateCampaignRequest.fromJson(Map<String, dynamic> json) {
    return CreateCampaignRequest(
      name: json['name'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      minQuantity: json['minQuantity'],
      maxQuantity: json['maxQuantity'],
      totalAmount: json['totalAmount'] ?? 0.0,
      status: json['status'],
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'minQuantity': minQuantity,
      'maxQuantity': maxQuantity,
      'totalAmount': totalAmount,
      'productId': productId,
    };

    // Only include status in the JSON if it's not null
    if (status != null) {
      data['status'] = status;
    }

    return data;
  }
}

class UpdateCampaignRequest {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final int minQuantity;
  final int maxQuantity;
  final double totalAmount;
  final String productId;

  UpdateCampaignRequest({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.minQuantity,
    required this.maxQuantity,
    required this.totalAmount,
    required this.productId,
  });

  factory UpdateCampaignRequest.fromJson(Map<String, dynamic> json) {
    return UpdateCampaignRequest(
      id: json['id'],
      name: json['name'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      minQuantity: json['minQuantity'],
      maxQuantity: json['maxQuantity'],
      totalAmount: json['totalAmount'] ?? 0.0,
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'minQuantity': minQuantity,
      'maxQuantity': maxQuantity,
      'totalAmount': totalAmount,
      'productId': productId,
    };
  }
}
