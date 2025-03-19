class CreateCampaignRequest {
  final String name;
  final String startDate;
  final String endDate;
  final int minQuantity;
  final int maxQuantity;
  final double totalAmount;
  final String status;
  final String productId;

  CreateCampaignRequest({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.minQuantity,
    required this.maxQuantity,
    required this.totalAmount,
    required this.status,
    required this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'minQuantity': minQuantity,
      'maxQuantity': maxQuantity,
      'totalAmount': totalAmount,
      'status': status,
      'productId': productId,
    };
  }
}
