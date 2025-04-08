class ShopDetailModel {
  final String storeName;
  final String operatingHours;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String? coverImageUrl;
  final String? logoImageUrl;

  ShopDetailModel({
    required this.storeName,
    required this.operatingHours,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.coverImageUrl,
    this.logoImageUrl,
  });

  factory ShopDetailModel.fromJson(Map<String, dynamic> json) {
    return ShopDetailModel(
      storeName: json['storeName'],
      operatingHours: json['operatingHours'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      coverImageUrl: json['coverImageUrl'],
      logoImageUrl: json['logoImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'operatingHours': operatingHours,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'coverImageUrl': coverImageUrl,
      'logoImageUrl': logoImageUrl,
    };
  }
}
