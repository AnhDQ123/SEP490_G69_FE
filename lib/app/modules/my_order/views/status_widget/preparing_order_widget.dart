import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../order_list_widget.dart';

class PreparingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const PreparingOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Đang chuẩn bị",
      getStatusColor: getStatusColor,
      actionWidgetBuilder: (order, total) {
        return ElevatedButton(
          onPressed: () {
            // TODO: Xử lý huỷ đơn
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.redAccent, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Huỷ đơn",
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.redAccent),
          ),
        );
      },
    );
  }
}

