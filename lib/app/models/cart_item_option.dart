class CartItemOption {
  final int? id;
  final int optionId;
  final int typeId;
  final String optionName;
  final String? image;
  final int cartItemId;
  double price;
  double? totalPrice;
  int quantity;

  CartItemOption({
    this.id,
    required this.optionId,
    required this.typeId,
    required this.optionName,
    this.image,
    required this.cartItemId,
    required this.price,
    this.totalPrice,
    required this.quantity,
  });

  factory CartItemOption.fromJson(Map<String, dynamic> json) {
    return CartItemOption(
      id: json['id'],
      optionId: json['optionId'],
      typeId: json['typeId'],
      optionName: json['optionName'],
      image: json['image'],
      cartItemId: json['cartItemId'],
      price: json['price'],
      totalPrice:
      json['totalPrice'] != null ? (json['totalPrice'] as num).toDouble() : null,
      quantity: json['quantity'],
    );
  }
}
