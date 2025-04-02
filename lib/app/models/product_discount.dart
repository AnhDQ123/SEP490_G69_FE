
import 'package:ffb_fe_flutter/app/models/food_option_model.dart';
import 'discount.dart';
import 'food_option.dart';

class ProductDiscount {
  final int id;
  final String name;
  final String manufacturer;
  final String supplier;
  int quantity;
  final String category;
  final String? type;
  final String status;
  final List<Discount> discount;  // Danh sách các đợt giảm giá
  final dynamic image;
  final String description;
  final double rate;
  final String shop;
  final double defaultPrice;  // Giá gốc
  final List<FoodOption> foodOptions; // Nếu có

  ProductDiscount({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.supplier,
    required this.quantity,
    required this.category,
    this.type,
    required this.status,
    required this.discount,
    required this.image,
    required this.description,
    required this.rate,
    required this.shop,
    required this.defaultPrice,
    required this.foodOptions,
  });

  factory ProductDiscount.fromJson(Map<String, dynamic> json) {
    return ProductDiscount(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      supplier: json['supplier'] ?? '',
      quantity: json['quantity'] ?? 0,
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      discount: json['discount'] != null
          ? (json['discount'] as List)
          .map((item) => Discount.fromJson(item))
          .toList()
          : [],
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      shop: json['shop'] ?? '',
      defaultPrice: (json['defaultPrice'] as num?)?.toDouble() ?? 0.0,
      foodOptions: json['foodOption'] != null
          ? (json['foodOption'] as List)
          .map((item) => FoodOption.fromJson(item))
          .toList()
          : [],
    );
  }
}