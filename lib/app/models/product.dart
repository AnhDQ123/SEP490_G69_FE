import 'food_option.dart';

class Product {
  final int? id;
  final String name;
  final String? description;
  final String? manufacturer;
  final String? supplier;
  final int? quantity;
  final String? category;
  final double? discount;
  final String? avatar; // Ảnh sản phẩm (URL)
  final String? expiryDate; // Ngày hết hạn
  final List<FoodOption>? foodOptions;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.manufacturer,
    this.supplier,
    this.quantity,
    this.category,
    this.discount,
    this.avatar,
    this.expiryDate, // Bổ sung ngày hết hạn
    required this.foodOptions,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Không có tên",
      description: json['description'],
      manufacturer: json['manufacturer'],
      supplier: json['supplier'],
      quantity: json['quantity'] ?? 0,
      category: json['category'],
      discount: json['discount']?.toDouble(),
      avatar: json['avatar'],
      expiryDate: json['expiryDate'], // ✅ Lấy ngày hết hạn từ JSON
      foodOptions: (json['foodOption'] as List<dynamic>?)
          ?.map((item) => FoodOption.fromJson(item))
          .toList(),
    );
  }
}
