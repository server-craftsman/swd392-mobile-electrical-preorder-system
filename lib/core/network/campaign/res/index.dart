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
  final Pageable pageable;
  final bool last;
  final int totalPages;
  final int totalElements;
  final bool first;
  final int size;
  final int number;
  final Sort sort;
  final int numberOfElements;
  final bool empty;

  CampaignData({
    required this.content,
    required this.pageable,
    required this.last,
    required this.totalPages,
    required this.totalElements,
    required this.first,
    required this.size,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.empty,
  });

  factory CampaignData.fromJson(Map<String, dynamic> json) {
    return CampaignData(
      content:
          (json['content'] as List)
              .map((item) => Campaign.fromJson(item))
              .toList(),
      pageable: Pageable.fromJson(json['pageable']),
      last: json['last'],
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      first: json['first'],
      size: json['size'],
      number: json['number'],
      sort: Sort.fromJson(json['sort']),
      numberOfElements: json['numberOfElements'],
      empty: json['empty'],
    );
  }
}

class Pageable {
  final int pageNumber;
  final int pageSize;
  final Sort sort;
  final int offset;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.pageNumber,
    required this.pageSize,
    required this.sort,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      sort: Sort.fromJson(json['sort']),
      offset: json['offset'],
      paged: json['paged'],
      unpaged: json['unpaged'],
    );
  }
}

class Sort {
  final bool empty;
  final bool sorted;
  final bool unsorted;

  Sort({required this.empty, required this.sorted, required this.unsorted});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      empty: json['empty'],
      sorted: json['sorted'],
      unsorted: json['unsorted'],
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
