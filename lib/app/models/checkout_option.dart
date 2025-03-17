class CheckoutOption {
  final String name;
  final int price; // Giá của option
  final String imageUrl; // Ảnh của option
  final int quantity; // Số lượng option

  CheckoutOption({
    required this.name,
    this.price = 0,
    this.imageUrl = '',
    this.quantity = 1,
  });
}
