import 'food_option_model.dart';

class ProductDetailModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final int quantity;
  final double rating;
  final List<String> sizes;
  final List<FoodOptionModel> foodOptions;

  ProductDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.rating,
    required this.sizes,
    required this.foodOptions,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['product_id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      quantity: json['quantity'] ?? 0,
      rating: (json['rate'] is num) ? (json['rate'] as num).toDouble() : 0.0,
      sizes: json['sizes'] != null ? List<String>.from(json['sizes']) : [],
      foodOptions: json['foodOption'] != null
          ? List<FoodOptionModel>.from(
          (json['foodOption'] as List)
              .map((e) => FoodOptionModel.fromJson(e)))
          : [],
    );
  }
}