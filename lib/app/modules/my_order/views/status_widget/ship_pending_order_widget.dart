import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/order.dart';
import '../../../../service/order_service.dart';
import '../../controllers/my_order_controller.dart';
import '../order_list_widget.dart';

class ShipPendingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShipPendingOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Chờ vận chuyển",
      getStatusColor: getStatusColor,
      actionWidgetBuilder: (order, total) {
        return ElevatedButton(
          onPressed: () {
            // Có thể bổ sung tính năng sau này như "Liên hệ shipper" chẳng hạn
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Chờ giao hàng",
            style: TextStyle(fontSize: 10),
          ),
        );
      },
    );
  }
}
