import 'order_item_option.dart';

class CartItemOptionDTO {
  int id;
  int optionId;
  int typeId;
  String optionName;
  String image;
  int cartItemId;
  double price;
  double totalPrice;
  int quantity;

  CartItemOptionDTO({
    required this.id,
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
      optionId: json['optionId'] ?? 0, // Thêm xử lý null
      typeId: json['typeId'] ?? 0, // Thêm xử lý null
      optionName: json['optionName'] ?? '',
      image: json['image'] ?? '',
      cartItemId: json['cartItemId'] ?? 0, // Thêm xử lý null
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Sửa thành as num?
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0, // Sửa thành as num?
      quantity: json['quantity'] ?? 1, // Thêm xử lý null
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