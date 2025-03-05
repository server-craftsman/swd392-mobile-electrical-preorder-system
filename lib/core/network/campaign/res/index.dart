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

class Product {
  final String id;
  final String productCode;
  final String name;
  final String slug;
  final int quantity;
  final String description;
  final double price;
  final int position;
  final String status;
  final Category category;
  final List<ImageProduct> imageProducts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;

  Product({
    required this.id,
    required this.productCode,
    required this.name,
    required this.slug,
    required this.quantity,
    required this.description,
    required this.price,
    required this.position,
    required this.status,
    required this.category,
    required this.imageProducts,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productCode: json['productCode'],
      name: json['name'],
      slug: json['slug'],
      quantity: json['quantity'],
      description: json['description'],
      price: json['price'],
      position: json['position'],
      status: json['status'],
      category: Category.fromJson(json['category']),
      imageProducts:
          (json['imageProducts'] as List)
              .map((item) => ImageProduct.fromJson(item))
              .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deleted: json['deleted'],
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}

class ImageProduct {
  final String altText;
  final String imageUrl;

  ImageProduct({required this.altText, required this.imageUrl});

  factory ImageProduct.fromJson(Map<String, dynamic> json) {
    return ImageProduct(altText: json['altText'], imageUrl: json['imageUrl']);
  }
}

class PageInfo {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  PageInfo({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      size: json['size'],
      number: json['number'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }
}
