import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/order.dart';
import '../../../my_order/views/order_list_widget.dart';

class ShopDeliveredOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopDeliveredOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Đã giao",
      getStatusColor: getStatusColor,
      isShopView: true, // ẩn shopName
      actionWidgetBuilder: (order, total) {
        return TextButton.icon(
          onPressed: () {
            // TODO: Thay bằng điều hướng sang màn hình chi tiết đánh giá
            Get.snackbar("Đánh giá", "Hiển thị đánh giá của khách hàng");
          },
          icon: const Icon(Icons.reviews, size: 14, color: Colors.blue),
          label: const Text(
            "Xem đánh giá",
            style: TextStyle(fontSize: 10, color: Colors.blue),
          ),
        );
      },
    );
  }
}
