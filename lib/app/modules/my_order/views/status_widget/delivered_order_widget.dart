import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../order_list_widget.dart';

class DeliveredOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const DeliveredOrderWidget({
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
      actionWidgetBuilder: (order, total) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: () {
                // TODO: Xử lý đánh giá
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.redAccent, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                "Trả hàng",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.redAccent),
              ),
            ),
            const SizedBox(width: 4),
            OutlinedButton(
              onPressed: () {
                // TODO: Xử lý trả hàng
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                "Đánh giá",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }
}
