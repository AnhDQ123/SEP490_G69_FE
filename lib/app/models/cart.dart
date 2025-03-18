import 'cart_item.dart';

class Cart {
  final int id;
  final int userId;
  final int shopId;
  final String shopName;
  final double price;
  final String? status;
  final List<CartItem> cartItemDTOList;

  Cart({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.price,
    this.status,
    required this.cartItemDTOList,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      shopId: json['shopId'],
      shopName: json['shopName'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
      cartItemDTOList: (json['cartItemDTOList'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}
