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
  final PageInfo page;

  ProductData({required this.content, required this.page});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      content:
          (json['content'] as List)
              .map((item) => Product.fromJson(item))
              .toList(),
      page: PageInfo.fromJson(json['page']),
    );
  }
}
