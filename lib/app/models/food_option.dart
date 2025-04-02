import 'dart:io';

class FoodOption {
  final int id;
  final String name;
  final double price;
  final String? description;
  // final String? image;
  dynamic image; // Cho phép cập nhật ảnh
  final int? typeId;
  final String? status;
  final int productId;

  FoodOption({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.image,
    this.typeId,
    this.status,
    required this.productId,
  });

  // Factory constructor để chuyển từ JSON thành đối tượng FoodOption
  factory FoodOption.fromJson(Map<String, dynamic> json) {
    return FoodOption(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      // image: json['image'],  // Lưu trữ URL hoặc Base64
      image: json['image'] != null ? File(json['image']) : null,
      typeId: json['type_id'],
      status: json['status'],
      productId: json['product_id'] ?? 0,
    );
  }

  // Phương thức để chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,  // Lưu URL hoặc Base64
      'type_id': typeId,
      'status': status,
      'product_id': productId,
    };
  }
}
