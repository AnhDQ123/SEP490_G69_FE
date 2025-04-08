import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../../../my_order/views/order_list_widget.dart';

class RejectedOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const RejectedOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Đã từ chối",
      getStatusColor: getStatusColor,
      isShopView: true, // ✅ THÊM VÀO ĐÂY

      actionWidgetBuilder: (order, total) {
        return const Text(
          "Đã từ chối",
          style: TextStyle(color: Colors.red, fontSize: 12),
        );
      },
    );
  }
}
