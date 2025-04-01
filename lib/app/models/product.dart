
import 'package:ffb_fe_flutter/app/models/food_option_model.dart';
import 'discount.dart';
import 'food_option.dart';

class Product {
  final int id;
  final String name;
  final String manufacturer;
  final String supplier;
  int quantity;
  final String category;
  final double discount;  // Danh sách các đợt giảm giá
  final String image;
  final String description;
  final double rate;
  final String shop;
  final double defaultPrice;  // Giá gốc
  final List<FoodOption> foodOptions; // Nếu có

  Product({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.supplier,
    required this.quantity,
    required this.category,
    required this.discount,
    required this.image,
    required this.description,
    required this.rate,
    required this.shop,
    required this.defaultPrice,
    required this.foodOptions,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      supplier: json['supplier'] ?? '',
      quantity: json['quantity'] ?? 0,
      category: json['category'] ?? '',
      discount: (json['discount'] is List && (json['discount'] as List).isEmpty)  // Kiểm tra nếu discount là danh sách rỗng
          ? 0.0  // Nếu là danh sách rỗng, gán discount là 0.0
          : (json['discount'] is num)  // Nếu discount là kiểu num, chuyển thành double
          ? (json['discount'] as num).toDouble()
          : 0.0,  // Nếu không phải num, gán giá trị mặc định là 0.0
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      shop: json['shopName'] ?? json['supplier'] ?? '',
      defaultPrice: (json['defaultPrice'] as num?)?.toDouble() ?? 0.0,
      foodOptions: json['foodOption'] != null
          ? (json['foodOption'] as List)
          .map((item) => FoodOption.fromJson(item))
          .toList()
          : [],
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'supplier': supplier,
      'quantity': quantity,
      'category': category,
      'discount': discount,
      'image': image,
      'description': description,
      'rate': rate,
      'shopName': shop,
      'defaultPrice': defaultPrice,
      'foodOption': foodOptions.map((item) => item.toJson()).toList(),
    };
  }
}