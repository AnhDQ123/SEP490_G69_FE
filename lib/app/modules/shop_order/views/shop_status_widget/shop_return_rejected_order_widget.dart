import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../../../my_order/views/order_list_widget.dart';

class ShopReturnRejectedOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopReturnRejectedOrderWidget({
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
      isShopView: true,
      actionWidgetBuilder: (order, total) {
        return OutlinedButton(
          onPressed: () {
            // 👉 Có thể điều hướng sang trang chi tiết trả hàng nếu muốn
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          child: const Text(
            "Chi tiết",
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        );
      },
    );
  }
}
