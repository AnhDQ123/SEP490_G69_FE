import 'order_item.dart';

class Order {
  final int id;
  final int ownerId;
  final int shipperId;
  final int shipMethodId;
  final int paymentMethodId;
  final int? voucherId;
  final double? voucherAmount;
  final String? address;
  final String shopName;
  final String shopAddress;
  final String phone;
  final int shopId;
  String status;
  final String? image;
  final double total;
  final DateTime? createdAt;
  final List<OrderItem> orderItem;
  final String? reason;
  final String ownerName;

  Order({
    required this.id,
    required this.ownerId,
    required this.shipperId,
    required this.shipMethodId,
    required this.paymentMethodId,
    this.voucherId,
    this.voucherAmount,
    this.address,
    required this.shopName,
    required this.shopAddress,
    required this.phone,
    required this.shopId,
    required this.status,
    this.image,
    required this.total,
    this.createdAt,
    required this.orderItem,
    this.reason,
    required this.ownerName,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      ownerId: json['ownerId'],
      shipperId: json['shipperId'],
      shipMethodId: json['shipMethodId'],
      paymentMethodId: json['paymentMethodId'],
      voucherId: json['voucherId'],
      voucherAmount: (json['voucherAmount'] ?? 0).toDouble(),
      address: json['address'],
      shopName: json['shopName'] ?? '',
      shopAddress: json['shopAddress'],
      phone: json['phone'],
      shopId: json['shopId'],
      status: json['status'] ?? 'UNKNOWN',
      image: json['image'],
      total: (json['total'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      reason: json['reason'],
      ownerName: json['ownerName'],
      orderItem: (json['orderItem'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}
