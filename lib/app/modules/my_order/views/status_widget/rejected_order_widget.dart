import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../order_list_widget.dart';

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
      status: "Bị từ chối",
      getStatusColor: getStatusColor,
      actionWidgetBuilder: (order, total) {
        return const SizedBox(); // Không có hành động cho đơn bị từ chối
      },
    );
  }
}
