import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../order_list_widget.dart';

class ShippingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShippingOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Đang giao",
      getStatusColor: getStatusColor,
      actionWidgetBuilder: (order, total) {
        return TextButton(
          onPressed: () {
            // TODO: Xử lý mua lại (hoặc hành động khác nếu cần)
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.redAccent, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            "Đã nhận được hàng",
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.redAccent),
          ),
        );
      },
    );
  }
}

