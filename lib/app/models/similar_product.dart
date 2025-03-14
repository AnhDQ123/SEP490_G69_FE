class SimilarProduct {
  final String imageUrl;
  final String name;
  final String shopName;
  final double price;
  int quantity;

  SimilarProduct({
    required this.imageUrl,
    required this.name,
    required this.shopName,
    required this.price,
    this.quantity = 1,
  });

  factory SimilarProduct.fromJson(Map<String, dynamic> json) {
    return SimilarProduct(
      imageUrl: json['image'] ?? '',
      name: json['name'] ?? '',
      shopName: json['shop_name'] ?? json['supplier'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "imageUrl": imageUrl,
      "name": name,
      "shopName": shopName,
      "price": price,
      "quantity": quantity,
    };
  }
}