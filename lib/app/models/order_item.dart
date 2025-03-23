import 'order_item_option.dart';

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final int? discountId;
  final double discount;
  final String? image;
  final double? price;
  final DateTime? createdAt;
  final int quantity;
  final double total;
  final List<OrderItemOption> orderItemOptions;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    this.discountId,
    required this.discount,
    this.image,
    this.price,
    this.createdAt,
    required this.quantity,
    required this.total,
    required this.orderItemOptions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
      productName: json['productName'],
      discountId: json['discountId'],
      discount: (json['discount'] ?? 0).toDouble(),
      image: json['image'],
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      quantity: json['quantity'],
      total: (json['total'] ?? 0).toDouble(),
      orderItemOptions: (json['orderItemOptions'] as List)
          .map((e) => OrderItemOption.fromJson(e))
          .toList(),
    );
  }
}
