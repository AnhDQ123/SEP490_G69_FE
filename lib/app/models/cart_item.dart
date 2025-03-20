import 'cart_item_option.dart';

class CartItem {
  final int id;
  final int cartId;
  final int productId;
  final String productName;
  final String? image;
  int quantity; // ❌ Bỏ `final`
  double totalPrice;
  List<CartItemOption> cartItemOptionDTOList;

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.productName,
    this.image,
    required this.quantity, // ✅ Không cần `final`
    required this.totalPrice,
    required this.cartItemOptionDTOList,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      cartId: json['cartId'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      image: json['image'],
      quantity: json['quantity'] ?? 1, // ✅ Giá trị có thể thay đổi sau
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      cartItemOptionDTOList: (json['cartItemOptionDTOList'] as List?)
          ?.map((item) => CartItemOption.fromJson(item))
          .toList() ??
          [],
    );
  }
}
