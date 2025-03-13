class Shop {
  final int shopId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String foodSafetyCertificate;
  final String registrationCertificate;
  final String address;
  final String backgroundImage;
  final String description;
  final bool isActive;
  final String logo;
  final String shopName;
  final String phone;
  final double rate;
  final int viewCount;
  final int userId;

  Shop({
    required this.shopId,
    required this.createdAt,
    required this.updatedAt,
    required this.foodSafetyCertificate,
    required this.registrationCertificate,
    required this.address,
    required this.backgroundImage,
    required this.description,
    required this.isActive,
    required this.logo,
    required this.shopName,
    required this.phone,
    required this.rate,
    required this.viewCount,
    required this.userId,
  });

  /// Danh sách shop mẫu
  static List<Shop> sampleShops = [
    Shop(
      shopId: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      foodSafetyCertificate: "cert_123",
      registrationCertificate: "reg_456",
      address: "123 Trần Duy Hưng, Hà Nội",
      backgroundImage: "assets/shop1_bg.png",
      description: "Quán ăn ngon chuyên về cơm rang",
      isActive: true,
      logo: "assets/shop1_logo.png",
      shopName: "Cơm rang Minh Nhật",
      phone: "0123456789",
      rate: 4.5,
      viewCount: 500,
      userId: 1001,
    ),
    Shop(
      shopId: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      foodSafetyCertificate: "cert_789",
      registrationCertificate: "reg_012",
      address: "456 Cầu Giấy, Hà Nội",
      backgroundImage: "assets/shop2_bg.png",
      description: "Trà sữa handmade, ngon tuyệt",
      isActive: true,
      logo: "assets/shop2_logo.png",
      shopName: "Trà sữa Anh Đức",
      phone: "0987654321",
      rate: 4.8,
      viewCount: 1000,
      userId: 1002,
    ),
  ];
}
