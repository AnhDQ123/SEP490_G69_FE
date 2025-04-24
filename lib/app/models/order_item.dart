import 'discount.dart';
import 'order_item_option.dart';

import 'order_item_option.dart';

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final int? discountId;
  final List<Discount>? discount; // Thay đổi từ discount/discountId sang danh sách
  final String image;
  final double price;
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
    required this.image,
    required this.price,
    this.createdAt,
    required this.quantity,
    required this.total,
    required this.orderItemOptions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: (json['id'] as int?) ?? 0, // Nếu id không có giá trị, gán 0
      orderId: (json['orderId'] as int?) ?? 0,
      productId: (json['productId'] as int?) ?? 0,
      productName: json['productName'] ?? 'Chưa có tên sản phẩm',  // Nếu null, gán giá trị mặc định
      discountId: json['discountId'],
      discount: (json['discount'] as List<dynamic>?)
          ?.map((e) => Discount.fromJson(e))
          .toList() ?? [],  // Nếu không có discount, gán danh sách trống
      image: json['image'] ?? '',  // Nếu null, gán chuỗi rỗng
      price: (json['price'] ?? 0).toDouble(),  // Nếu giá là null, gán 0
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      quantity: json['quantity'] ?? 0,  // Nếu quantity là null, gán 0
      total: (json['total'] ?? 0).toDouble(),
      orderItemOptions: (json['orderItemOptions'] as List)
          .map((e) => OrderItemOption.fromJson(e))
          .toList(),
    );
  }




  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      // 'orderId': orderId,
      'productId': productId,
      'productName': productName, // Thêm
      'image': image, // Thêm
      'price': price,
      'discountId': discountId,
      'quantity': quantity,
      'total': total,
      'discount': discount?.map((d) => d.toJson()).toList(), // Gửi danh sách discounts
      'createdAt': createdAt?.toIso8601String(), // Sửa ở đây
      'orderItemOptions': orderItemOptions.map((opt) => opt.toJson()).toList(),
    };
  }
}
