class SimilarProduct {
  final String imageUrl;
  final String name;
  final String shopName;
  final double price;
  final double rating; // Đánh giá sản phẩm
  final double discount; // ✅ Thêm trường giảm giá
  int quantity;

  SimilarProduct({
    required this.imageUrl,
    required this.name,
    required this.shopName,
    required this.price,
    required this.rating,
    this.discount = 0.0,
    this.quantity = 1,
  });

  factory SimilarProduct.fromJson(Map<String, dynamic> json) {
    return SimilarProduct(
      imageUrl: json['image'] ?? '',
      name: json['name'] ?? '',
      shopName: json['shop_name'] ?? json['supplier'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      rating: (json['rate'] is num) ? (json['rate'] as num).toDouble() : 0.0,
      discount: (json['discount'] != null && json['discount'] is num)
          ? (json['discount'] as num).toDouble()
          : 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "imageUrl": imageUrl,
      "name": name,
      "shopName": shopName,
      "price": price,
      "rate": rating,
      "discount": discount,
      "quantity": quantity,
    };
  }
}
