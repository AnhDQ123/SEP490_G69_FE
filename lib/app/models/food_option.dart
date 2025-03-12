import 'dart:io';

class FoodOption {
  final int id;
  final String name;
  final double price;
  final String? description;
  File? image; // Cho phép cập nhật ảnh
  final int? typeId;
  final String? status;

  FoodOption({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.image,
    this.typeId,
    this.status,
  });

  factory FoodOption.fromJson(Map<String, dynamic> json) {
    return FoodOption(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      image: json['image'] != null ? File(json['image']) : null,
      typeId: json['type_id'],
      status: json['status'],
    );
  }

}
