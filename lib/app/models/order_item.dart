import 'order_item_option.dart';

import 'order_item_option.dart';

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String dishName; // Thêm
  final String imageUrl; // Thêm
  final int? discountId;       // mới thêm
  final double price;
  final int quantity;
  final double total;
  final double discount; // Thêm
  final DateTime createdAt;
  final List<OrderItemOption> options; // Tùy chọn sản phẩm

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.dishName, // Thêm
    required this.imageUrl, // Thêm
    required this.price,
    this.discountId,
    required this.quantity,
    required this.total,
    required this.discount, // Thêm
    required this.createdAt,
    required this.options,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: (json['id'] as int?) ?? 0, // Nếu null, gán 0
      orderId: (json['orderId'] as int?) ?? 0, // Nếu null, gán 0
      productId: (json['productId'] as int?) ?? 0, // Nếu null, gán 0
      dishName: json['productName'] ?? 'Không có tên', // Nếu null, gán giá trị mặc định
      imageUrl: json['image'] ?? 'https://image.pngaaa.com/305/269305-middle.png', // Nếu null, gán chuỗi rỗng
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Nếu null, gán 0.0
      discountId: (json['discountId'] as int?) ?? 0,
      quantity: (json['quantity'] as int?) ?? 1, // Nếu null, gán 1
      total: (json['total'] as num?)?.toDouble() ?? 0.0, // Nếu null, gán 0.0
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0, // Nếu null, gán 0.0
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(), // Kiểm tra null
      options: (json['orderItemOptions'] as List?)
          ?.map((opt) => OrderItemOption.fromJson(opt as Map<String, dynamic>))
          .toList() ?? [], // Nếu null, trả về danh sách rỗng
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'productName': dishName, // Thêm
      'image': imageUrl, // Thêm
      'price': price,
      'discountId': discountId,
      'quantity': quantity,
      'total': total,
      'discount': discount, // Thêm
      'createdAt': createdAt.toIso8601String(),
      'orderItemOptions': options.map((opt) => opt.toJson()).toList(),
    };
  }
}
