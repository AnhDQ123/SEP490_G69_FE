import 'discount.dart';
import 'food_option.dart';

class Product {
  final int id;
  final String name;
  final String manufacturer;
  final String supplier;
  int quantity;
  final String category;
  final List<Discount> discount;
  final String image;
  final String description;
  final double rate;
  final String shop;
  final double defaultPrice;
  final List<FoodOption> foodOptions;
  final int shopId;

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
    required this.shopId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Xử lý trường hợp foodOption null hoặc không phải List
    List<FoodOption> parsedFoodOptions = [];
    if (json['foodOption'] != null && json['foodOption'] is List) {
      try {
        parsedFoodOptions = (json['foodOption'] as List)
            .map((item) => FoodOption.fromJson(item))
            .toList();
      } catch (e) {
        print('⚠️ Lỗi khi parse foodOption: $e');
      }
    } else {
      print("❗ [Product] Không có foodOption hoặc định dạng không đúng cho productId: ${json['id']}");
    }

    // Xử lý trường hợp discount null
    List<Discount> parsedDiscounts = [];
    if (json['discount'] != null && json['discount'] is List) {
      try {
        parsedDiscounts = (json['discount'] as List)
            .map((item) => Discount.fromJson(item))
            .toList();
      } catch (e) {
        print('⚠️ Lỗi khi parse discount: $e');
      }
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      supplier: json['supplier'] ?? '',
      quantity: json['quantity'] ?? 0,
      category: json['category'] ?? '',
      discount: parsedDiscounts,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      shop: json['shopName'] ?? json['supplier'] ?? '',
      defaultPrice: (json['defaultPrice'] as num?)?.toDouble() ?? 0.0,
      foodOptions: parsedFoodOptions,
      shopId: json['shopId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'manufacturer': manufacturer,
    'supplier': supplier,
    'quantity': quantity,
    'category': category,
    'discount': discount.map((e) => e.toJson()).toList(),
    'image': image,
    'description': description,
    'rate': rate,
    'shopName': shop,
    'defaultPrice': defaultPrice,
    'foodOption': foodOptions.map((e) => e.toJson()).toList(),
    'shopId': shopId,
  };
}