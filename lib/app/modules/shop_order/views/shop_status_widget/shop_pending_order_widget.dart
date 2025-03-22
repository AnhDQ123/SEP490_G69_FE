import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/order.dart';
import '../../../../service/order_service.dart';
import '../../../my_order/views/order_list_widget.dart';
import '../../controllers/shop_order_controller.dart';

class ShopPendingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopPendingOrderWidget({
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
      isShopView: true, // ✅ THÊM VÀO ĐÂY

      actionWidgetBuilder: (order, total) {
        return Row(
          children: [
            OutlinedButton(
              onPressed: () async {
                try {
                  await OrderService().acceptOrder(order.id);
                  Get.snackbar("✅ Thành công", "Đã xác nhận đơn hàng");
                  Get.find<ShopOrderController>().fetchAll();
                } catch (_) {
                  Get.snackbar("❌ Lỗi", "Không thể xác nhận đơn");
                }
              },
              child: const Text("Xác nhận", style: TextStyle(fontSize: 10)),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () async {
                try {
                  await OrderService().rejectOrder(order.id);
                  Get.snackbar("🚫 Đã từ chối", "Đơn hàng đã bị từ chối");
                  Get.find<ShopOrderController>().fetchAll();
                } catch (_) {
                  Get.snackbar("❌ Lỗi", "Không thể từ chối đơn");
                }
              },
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Từ chối", style: TextStyle(fontSize: 10)),
            ),
          ],
        );
      },
    );
  }
}
