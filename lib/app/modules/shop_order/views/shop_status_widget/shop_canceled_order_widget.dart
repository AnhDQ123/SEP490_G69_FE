import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/order.dart';
import '../../../my_order/views/order_list_widget.dart';

class ShopCanceledOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopCanceledOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Đã huỷ",
      getStatusColor: getStatusColor,
      isShopView: true,
      actionWidgetBuilder: (order, total) {
        return OutlinedButton.icon(
          onPressed: () {
            // 🧠 TODO: sau này show popup hoặc navigate đến chi tiết lý do huỷ
            Get.dialog(AlertDialog(
              title: const Text("Lý do huỷ đơn"),
              content: Text(
                "Khách đã huỷ đơn hàng này.\n(Mô phỏng lý do ở đây – có thể thêm từ backend nếu cần)",
                style: const TextStyle(fontSize: 12),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Đóng"),
                ),
              ],
            ));
          },
          icon: const Icon(Icons.info_outline, size: 12),
          label: const Text(
            "Chi tiết huỷ",
            style: TextStyle(fontSize: 10),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey, width: 1.0),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      },
    );
  }
}
