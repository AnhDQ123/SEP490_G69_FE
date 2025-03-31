import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/order.dart';
import '../../../my_order/views/order_list_widget.dart';

class ShopWaitingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopWaitingOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Chờ xử lý", // hoặc tên status bạn dùng trong hệ thống
      getStatusColor: getStatusColor,
      isShopView: true,
      actionWidgetBuilder: (order, total) {
        return TextButton.icon(
          onPressed: () {
            Get.snackbar("Thông báo", "Chưa có hành động cụ thể cho trạng thái này.");
          },
          icon: const Icon(Icons.hourglass_top, size: 14, color: Colors.orange),
          label: const Text(
            "Chờ xử lý",
            style: TextStyle(fontSize: 10, color: Colors.orange),
          ),
        );
      },
    );
  }
}
