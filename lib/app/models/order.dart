import 'order_item.dart';

class Order {
  final int id;
  final int ownerId;
  final int? shipperId;  // Cho phép null
  int shipMethodId;
  String? shipMethodName;
  double shippingFee;
  int paymentMethodId;
  String? paymentMethodName;
  int? voucherId;
  double voucherAmount;
  final String address;
  final String shopName;
  final String? shopAddress;
  final String phone;
  final int shopId;
  String status;
  final String? image;
  double total;
  final DateTime? createdAt;
  final List<OrderItem> orderItem;
  final String? reason;
  final String ownerName;
  final String? paymentProof;


  Order({
    required this.id,
    required this.ownerId,
    this.shipperId,  // Bỏ required vì có thể null
    required this.shipMethodId,
    required this.paymentMethodId,
    this.paymentMethodName,
    this.voucherId,
    required this.voucherAmount,
    required this.address,
    required this.shopName,
    this.shopAddress,
    required this.phone,
    required this.shopId,
    required this.status,
    this.image,
    required this.total,
    this.createdAt,
    required this.orderItem,
    this.reason,
    required this.ownerName,
    this.paymentProof,
    this.shipMethodName,
    required this.shippingFee,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['id'] as int?) ?? 0, // Nếu không có id, gán 0
      ownerId: (json['ownerId'] as int?) ?? 0,
      shipperId: json['shipperId'] as int?,  // Cho phép null
      shipMethodId: (json['shipMethodId'] as int?) ?? 0,
      paymentMethodId: (json['paymentMethodId'] as int?) ?? 0,
      paymentMethodName: json['paymentMethodName'] as String?,
      voucherId: json['voucherId'] as int?,
      voucherAmount: (json['voucherAmount'] ?? 0).toDouble(),
      address: json['address'] as String? ?? '',  // Nếu address là null, gán chuỗi rỗng
      shopName: json['shopName'] as String? ?? '',
      shopAddress: json['shopAddress'] as String?,
      phone: json['phone'] as String? ?? '',  // Nếu phone là null, gán chuỗi rỗng
      shopId: (json['shopId'] as int?) ?? 0,
      status: json['status'] as String? ?? 'UNKNOWN', // Cung cấp giá trị mặc định nếu null
      image: json['image'] as String?,
      total: (json['total'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      reason: json['reason'] as String?,
      ownerName: json['ownerName'] as String? ?? '',
      orderItem: (json['orderItem'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],  // Nếu không có orderItem, gán danh sách trống
      paymentProof: json['paymentProof'] as String?,
      shipMethodName: json['shipMethodName'] as String?,
      shippingFee: (json['shippingFee'] ?? 0).toDouble(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'shopName': shopName,
      'ownerId': ownerId,
      'shipperId': shipperId,
      'shipMethodId': shipMethodId,
      'paymentMethodId': paymentMethodId,
      'paymentMethodName': paymentMethodName,
      'voucherId': voucherId,
      'voucherAmount': voucherAmount,
      'address': address,
      'total': total,
      'createdAt': createdAt?.toIso8601String(), // Sửa ở đây - convert DateTime sang String
      'status': status,
      'orderItem': orderItem.map((item) => item.toJson()).toList(),
      'reason': reason,
      'shopId': shopId,
      'image': image,
      'paymentProof': paymentProof,
      'shipMethodName': shipMethodName,
      'shippingFee': shippingFee,

    };
  }
}
