import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../models/order.dart';
import '../../../../service/order_service.dart';
import '../../controllers/my_order_controller.dart';
import '../order_list_widget.dart';
import 'cancel_reason.dart';

class PendingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const PendingOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Chờ xác nhận",
      getStatusColor: getStatusColor,
      actionWidgetBuilder: (order, total) {
        return OutlinedButton(
            onPressed: () async {
              final reason = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => CancelReasonSheet(),
              );

              if (reason != null && reason.isNotEmpty) {
                // 🧾 In ra lý do hoặc xử lý nội bộ
                print("Lý do huỷ đơn: $reason");

                // Gọi huỷ đơn như cũ (không cần truyền lý do)
                await OrderService().cancelOrder(order.id);

                // Thông báo và load lại danh sách
                Get.snackbar("Thông báo", "Đơn hàng đã được huỷ", snackPosition: SnackPosition.BOTTOM);
                Get.find<MyOrderController>().loadOrders();
              }
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
