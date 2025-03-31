import 'order_item_option.dart';

class CartItemOptionDTO {
  int? id;
  int optionId;
  int typeId;
  String optionName;
  String image;
  int cartItemId;
  double price;
  double totalPrice;
  int quantity;

  CartItemOptionDTO({
    this.id,
    required this.optionId,
    required this.typeId,
    required this.optionName,
    required this.image,
    required this.cartItemId,
    required this.price,
    required this.totalPrice,
    required this.quantity,
  });

  factory CartItemOptionDTO.fromJson(Map<String, dynamic> json) {
    return CartItemOptionDTO(
      id: json['id'],
      optionId: json['optionId'],
      typeId: json['typeId'] ?? 0,
      optionName: json['optionName'] ?? '',
      image: json['image'] ?? '',
      cartItemId: json['cartItemId'],
      price: (json['price'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      quantity: (json['quantity'] ?? 1) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'optionId': optionId,
      'typeId': typeId,
      'optionName': optionName,
      'image': image,
      'cartItemId': cartItemId,
      'price': price,
      'totalPrice': totalPrice,
      'quantity': quantity,
    };
  }

  OrderItemOption toOrderItemOption() {
    return OrderItemOption(
      id: 0,
      orderItemId: 0,
      optionId: optionId,
      typeId: typeId,
      optionName: optionName,
      price: price,
      total: totalPrice,
      quantity: quantity,
    );
  }

}
