class Product {
  final String imageUrl;
  final String name;
  final double rating;
  final double price;
  final String shopName; // thêm tên shop
  final double discount; // thêm discount (phần trăm giảm giá)

  Product({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
    required this.shopName,
    required this.discount,
  });
}
