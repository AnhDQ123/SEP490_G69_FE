import 'order_item.dart';

class Order {
  final int id;
  final String shopName;
  final int ownerId;
  final int? shipperId;
  final int shipMethodId;
  final int paymentMethodId;
  final int? voucherId;
  final double voucherAmount;
  final String address;
  final double total;
  final DateTime createdAt;
  final String status;
  final String? reason;
  final List<OrderItem> items;

  final int shopId;      // ✅ Thêm
  final String? image;    // ✅ Thêm

  final String? paymentProof;


  Order({
    required this.id,
    required this.shopName,
    required this.ownerId,
    this.shipperId,
    required this.shipMethodId,
    required this.paymentMethodId,
    this.voucherId,
    required this.voucherAmount,
    required this.address,
    required this.total,
    required this.createdAt,
    required this.status,
    required this.items,
    this.reason,
    required this.shopId,       // ✅ Gán vào constructor
    this.image,        // ✅ Gán vào constructor
    this.paymentProof,

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
      voucherAmount: (json['voucherAmount'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? 'Không có địa chỉ',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      items: (json['orderItem'] as List?)
          ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      status: json['status'] ?? 'UNKNOWN',
      reason: json['reason'] ?? '',
      shopId: (json['shopId'] as int?) ?? 0,
      image: json['image'] as String?,          // ✅ Parse
      paymentProof: json['paymentProof'] as String?,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'ownerId': ownerId,
      'shipperId': shipperId,
      'shipMethodId': shipMethodId,
      'paymentMethodId': paymentMethodId,
      'voucherId': voucherId,
      'voucherAmount': voucherAmount,
      'address': address,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'orderItem': items.map((item) => item.toJson()).toList(),
      'reason': reason,
      'shopId': shopId,         // ✅ Xuất ra JSON nếu cần
      'image': image,           // ✅ Xuất ra JSON nếu cần
      'paymentProof': paymentProof,

    };
  }
}
