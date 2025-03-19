import 'order_item.dart';

class Order {
  final int id;
  final String shopName;
  final int ownerId;
  final int? shipperId;
  final int shipMethodId;
  final int paymentMethodId;
  final int? voucherId;
  final double voucherAmount; // thêm trường voucherAmount
  final int? discountId;
  final String address;
  final double total;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.shopName,
    required this.ownerId,
    this.shipperId,
    required this.shipMethodId,
    required this.paymentMethodId,
    this.voucherId,
    required this.voucherAmount,
    this.discountId,
    required this.address,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['id'] as int?) ?? (json['orderId'] as int?) ?? 0,
      shopName: json['shopName'] ?? '',
      ownerId: (json['ownerId'] as int?) ?? 0,
      shipperId: json['shipperId'] as int?,
      shipMethodId: (json['shipMethodId'] as int?) ?? 0,
      paymentMethodId: (json['paymentMethodId'] as int?) ?? 0,
      voucherId: json['voucherId'] as int?,
      voucherAmount: (json['voucherAmount'] as num?)?.toDouble() ?? 0.0, // parse voucherAmount
      discountId: json['discountId'] as int?,
      address: json['address'] ?? 'Không có địa chỉ',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      items: (json['orderItem'] as List?)
          ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': id,
      'shopName': shopName,
      'ownerId': ownerId,
      'shipperId': shipperId,
      'shipMethodId': shipMethodId,
      'paymentMethodId': paymentMethodId,
      'voucherId': voucherId,
      'voucherAmount': voucherAmount, // xuất voucherAmount
      'discountId': discountId,
      'address': address,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'orderItem': items.map((item) => item.toJson()).toList(),
    };
  }
}

