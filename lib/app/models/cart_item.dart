import 'cart_item_option.dart';

class CartItem {
  final int id;
  final int cartId;
  final int productId;
  final String productName;
  final String? image;
  final double? price;
  final double totalPrice;
  final int quantity;
  final List<CartItemOption> cartItemOptionDTOList;

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.productName,
    this.image,
    this.price,
    required this.totalPrice,
    required this.quantity,
    required this.cartItemOptionDTOList,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      cartId: json['cartId'],
      productId: json['productId'],
      productName: json['productName'],
      image: json['image'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      quantity: json['quantity'],
      cartItemOptionDTOList: (json['cartItemOptionDTOList'] as List)
          .map((item) => CartItemOption.fromJson(item))
          .toList(),
    );
  }
}
