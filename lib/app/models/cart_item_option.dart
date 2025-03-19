class CartItemOption {
  final int? id;
  final int optionId;
  final int typeId;
  final String optionName;
  final String? image;
  final int cartItemId;
  final double? price;
  final double? totalPrice;
  final int quantity;

  CartItemOption({
    this.id,
    required this.optionId,
    required this.typeId,
    required this.optionName,
    this.image,
    required this.cartItemId,
    this.price,
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
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      totalPrice:
      json['totalPrice'] != null ? (json['totalPrice'] as num).toDouble() : null,
      quantity: json['quantity'],
    );
  }
}
