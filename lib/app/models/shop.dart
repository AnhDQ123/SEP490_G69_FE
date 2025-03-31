import 'dart:convert';

class ShopDTO {
  final int id;
  final String name;
  final String description;
  final String logo;
  final String backgroundImage;
  final String menu;
  final String phone;
  final String address;
  final double rate;
  final bool isShipping;
  final bool isOpening;

  ShopDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.backgroundImage,
    required this.menu,
    required this.phone,
    required this.address,
    required this.rate,
    required this.isShipping,
    required this.isOpening,
  });

  // Factory constructor to create a ShopDTO from JSON
  factory ShopDTO.fromJson(Map<String, dynamic> json) {
    return ShopDTO(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      backgroundImage: json['backgroundImage'] ?? '',
      menu: json['menu'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      rate: json['rate']?.toDouble() ?? 0.0,
      isShipping: json['isShipping'] ?? false,
      isOpening: json['isOpening'] ?? false,
    );
  }

  // Convert ShopDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'backgroundImage': backgroundImage,
      'menu': menu,
      'phone': phone,
      'address': address,
      'rate': rate,
      'isShipping': isShipping,
      'isOpening': isOpening,
    };
  }
}
