import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../models/order.dart';
import '../../../../service/order_service.dart';
import '../../controllers/my_order_controller.dart';
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
          onPressed: () async {
            try {
              // Gọi API hủy đơn hàng
              await OrderService().cancelOrder(order.id, order.reason!);
              // Hiển thị thông báo thành công (có thể dùng Get.snackbar hoặc toast)
              Get.snackbar("Thông báo", "Đơn hàng đã được huỷ", snackPosition: SnackPosition.BOTTOM);
              // Sau đó, bạn nên refresh lại danh sách đơn hàng
              Get.find<MyOrderController>().loadOrders();
              // Ví dụ: gọi lại controller.loadOrdersByStatus() nếu sử dụng GetX Controller
              // hoặc tự cập nhật trạng thái của order trong danh sách.
            } catch (e) {
              Get.snackbar("Lỗi", "Huỷ đơn không thành công", snackPosition: SnackPosition.BOTTOM);
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

