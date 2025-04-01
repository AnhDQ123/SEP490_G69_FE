import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../order_list_widget.dart';

class ReturnedOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ReturnedOrderWidget({
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
      actionWidgetBuilder: (order, total) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: () {
                // TODO: Xử lý chi tiết đơn đã trả
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                "Chi tiết",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
