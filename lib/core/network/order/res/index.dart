class Order {
  final String id;
  final int quantity;
  final String status;
  final double totalAmount;
  final User user;
  final Campaign campaign;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;

  Order({
    required this.id,
    required this.quantity,
    required this.status,
    required this.totalAmount,
    required this.user,
    required this.campaign,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? '',
      totalAmount: json['totalAmount'] != null ? (json['totalAmount'] as num).toDouble() : 0.0,
      user: User.fromJson(json['user'] ?? {}),
      campaign: Campaign.fromJson(json['campaign'] ?? {}),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      deleted: json['deleted'] ?? false,
    );
  }
}

class User {
  final String id;
  final String username;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String status;
  final String role;
  final String avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool verified;
  final bool deleted;

  User({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.status,
    required this.role,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    required this.verified,
    required this.deleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? '',
      role: json['role'] ?? '',
      avatar: json['avatar'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      verified: json['verified'] ?? false,
      deleted: json['deleted'] ?? false,
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
      totalAmount: json['totalAmount'].toDouble(),
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
  final List<dynamic> imageProducts;
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
      price: json['price'].toDouble(),
      position: json['position'],
      status: json['status'],
      category: Category.fromJson(json['category']),
      imageProducts: json['imageProducts'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deleted: json['deleted'],
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

