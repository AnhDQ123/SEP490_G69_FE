import 'order_item.dart';
import 'voucher.dart';

class Order {
  final String shopName;
  final List<OrderItem> items;
  final Voucher? voucher; // Voucher của đơn hàng, có thể null nếu không có

  Order({
    required this.shopName,
    required this.items,
    this.voucher,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      shopName: json['shopName'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      voucher: json['voucher'] != null ? Voucher.fromJson(json['voucher']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopName': shopName,
      'items': items.map((item) => item.toJson()).toList(),
      'voucher': voucher?.toJson(),
    };
  }
}
