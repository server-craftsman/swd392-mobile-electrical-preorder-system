import '../../category/res/index.dart';
import '../../image_product/res/index.dart';
import '../../page_info/res/index.dart';

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
    // Parse image products safely
    List<ImageProduct> images = [];
    if (json['imageProducts'] != null && json['imageProducts'] is List) {
      images =
          (json['imageProducts'] as List)
              .map((item) => ImageProduct.fromJson(item))
              .toList();
    }

    // Create category safely
    Category category;
    try {
      category = Category.fromJson(json['category'] ?? {});
    } catch (e) {
      print('Error parsing category: $e');
      category = Category(id: '', name: 'Unknown');
    }

    return Product(
      id: json['id'] ?? '',
      productCode: json['productCode'] ?? '',
      name: json['name'] ?? 'Unknown Product',
      slug: json['slug'] ?? '',
      quantity: json['quantity'] ?? 0,
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      position: json['position'] ?? 0,
      status: json['status'] ?? 'UNAVAILABLE',
      category: category,
      imageProducts: images,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
      deleted: json['deleted'] ?? false,
    );
  }
}

class ProductResponse {
  final String message;
  final ProductData data;

  ProductResponse({required this.message, required this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      message: json['message'],
      data: ProductData.fromJson(json['data']),
    );
  }
}

class ProductData {
  final List<Product> content;
  final int totalPages;
  final int totalElements;
  final bool first;
  final bool last;
  final int size;
  final int number;

  ProductData({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.first,
    required this.last,
    required this.size,
    required this.number,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    List<Product> products = [];
    if (json['content'] != null && json['content'] is List) {
      products =
          (json['content'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
    }

    return ProductData(
      content: products,
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      first: json['first'] ?? true,
      last: json['last'] ?? true,
      size: json['size'] ?? 0,
      number: json['number'] ?? 0,
    );
  }
}
