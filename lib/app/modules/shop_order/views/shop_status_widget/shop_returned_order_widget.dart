import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../../../my_order/views/order_list_widget.dart';

class ShopReturnedOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopReturnedOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Đã trả",
      getStatusColor: getStatusColor,
      isShopView: true, // ✅ ẩn tên shop, chỉ hiện ID đơn
      actionWidgetBuilder: (order, total) {
        return OutlinedButton(
          onPressed: () {
            // 👉 Điều hướng sang trang chi tiết trả hàng
            // hoặc hiển thị chi tiết đơn
            // Bạn có thể dùng Get.toNamed nếu cần
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.green, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            "Xem chi tiết",
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.green),
          ),
        );
      },
    );
  }
}
