import 'discount.dart';
import 'food_option.dart';

class Product {
  final int id;
  final String name;
  final String manufacturer;
  final String supplier;
  int quantity;
  final String category;
  final List<Discount> discount;  // Danh sách các đợt giảm giá
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'supplier': supplier,
      'quantity': quantity,
      'category': category,
      'discount': discount.map((item) => item.toJson()).toList(),
      'image': image,
      'description': description,
      'rate': rate,
      'shop': shop,
      'defaultPrice': defaultPrice,
      'foodOption': foodOptions.map((item) => item.toJson()).toList(),
    };
  }
}