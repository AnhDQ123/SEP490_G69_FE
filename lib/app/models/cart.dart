import 'cart_item.dart';

class CartModel {
  final int cartId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final double total;
  final int userId;
  final List<CartItem> items; // Danh sách sản phẩm trong giỏ hàng

  CartModel({
    required this.cartId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.total,
    required this.userId,
    required this.items,
  });

  double calculateTotal() {
    return items.fold(0, (sum, item) => sum + item.getTotalPrice());
  }
}
