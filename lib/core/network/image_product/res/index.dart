class ImageProduct {
  final String altText;
  final String imageUrl;

  ImageProduct({required this.altText, required this.imageUrl});

  factory ImageProduct.fromJson(Map<String, dynamic> json) {
    return ImageProduct(altText: json['altText'], imageUrl: json['imageUrl']);
  }
}
