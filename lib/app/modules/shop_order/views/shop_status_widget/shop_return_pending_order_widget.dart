import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../models/order.dart';
import '../../../my_order/views/order_list_widget.dart';
import '../../controllers/shop_order_controller.dart';

class ShopReturnPendingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopReturnPendingOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Chờ xử lý trả",
      getStatusColor: getStatusColor,
      isShopView: true, // ✅ nếu cần ẩn tên shop và hiện ID đơn
      actionWidgetBuilder: (order, total) {
        return Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            OutlinedButton(
              onPressed: () async {
                final result = await Get.toNamed('/return-order-detail-page', arguments: order.id);
                if (result == true) {
                  // ✅ Nếu màn detail trả về true → làm mới danh sách
                  Get.find<ShopOrderController>().fetchAll();
                }
              },

              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                minimumSize: const Size(0, 28),
              ),
              child: const Text("Xem chi tiết", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600)
              ),
            ),
          ],
        );
      },
    );
  }
}
