class FoodOptionModel {
  final int id;
  final String name;
  final double price;
  final String image;
  final int typeId;
  final String status;
  final int productId;

  FoodOptionModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.typeId,
    required this.status,
    required this.productId,
  });

  factory FoodOptionModel.fromJson(Map<String, dynamic> json) {
    return FoodOptionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      image: json['image'] ?? '',
      typeId: json['type_id'] ?? 0,
      status: json['status'] ?? '',
      productId: json['product_id'] ?? 0,
    );
  }
}
