class Category {
  final String id;
  final String name;
  final String image;
  final String createdAt;
  final String updatedAt;
  final bool deleted;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      deleted: json['deleted'] ?? false,
    );
  }
}
