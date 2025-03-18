import 'order_item.dart';
import 'voucher.dart';

class Order {
  final int id;
  final String shopName; // Thêm shopName
  final int ownerId;
  final int? shipperId;
  final int shipMethodId;
  final int paymentMethodId;
  final int? voucherId;
  final int? discountId;
  final String address;
  final double total;
  final DateTime createdAt;
  final List<OrderItem> items;
  final Voucher? voucher; // Thêm voucher (có thể null)

  Order({
    required this.id,
    required this.shopName, // Thêm
    required this.ownerId,
    this.shipperId,
    required this.shipMethodId,
    required this.paymentMethodId,
    this.voucherId,
    this.discountId,
    required this.address,
    required this.total,
    required this.createdAt,
    required this.items,
    this.voucher, // Thêm
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['orderId'] as int?) ?? 0, // Nếu null, gán 0
      shopName: json['shopName'] ?? '', // Nếu null, gán chuỗi rỗng
      ownerId: (json['ownerId'] as int?) ?? 0, // Nếu null, gán 0
      shipperId: json['shipperId'] as int?, // Không ép kiểu nếu null
      shipMethodId: (json['shipMethodId'] as int?) ?? 0, // Nếu null, gán 0
      paymentMethodId: (json['paymentMethodId'] as int?) ?? 0, // Nếu null, gán 0
      voucherId: json['voucherId'] as int?, // Không ép kiểu nếu null
      discountId: json['discountId'] as int?, // Không ép kiểu nếu null
      address: json['address'] ?? 'Không có địa chỉ', // Nếu null, gán giá trị mặc định
      total: (json['total'] as num?)?.toDouble() ?? 0.0, // Nếu null, gán 0.0
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(), // Kiểm tra null
      items: (json['orderItem'] as List?)
          ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [], // Nếu null, trả về danh sách rỗng
      voucher: json['voucher'] != null ? Voucher.fromJson(json['voucher']) : null, // Kiểm tra null
    );
  }




  Map<String, dynamic> toJson() {
    return {
      'orderId': id,
      'shopName': shopName, // Thêm
      'ownerId': ownerId,
      'shipperId': shipperId,
      'shipMethodId': shipMethodId,
      'paymentMethodId': paymentMethodId,
      'voucherId': voucherId,
      'discountId': discountId,
      'address': address,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'orderItem': items.map((item) => item.toJson()).toList(),
      'voucher': voucher?.toJson(), // Thêm
    };
  }
}

