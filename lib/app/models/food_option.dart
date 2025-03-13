class FoodOption {
  final int foodOptionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String image;
  final String name;
  final double price;
  int quantity;
  final bool isActive;
  final int productId;
  final int typeId; // typeId: 1 = size, 2+ = option

  FoodOption({
    required this.foodOptionId,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.isActive,
    required this.productId,
    required this.typeId,
  });

  bool get isSize => typeId == 1; // Xác định đây có phải là size không

  // Hàm cập nhật số lượng
  void updateQuantity(int newQuantity) {
    if (newQuantity >= 0) {
      quantity = newQuantity;
    }
  }
}
