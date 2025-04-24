import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../order_list_widget.dart';
import 'package:get/get.dart';

class ReturnRejectedOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ReturnRejectedOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Từ chối trả",
      getStatusColor: getStatusColor,
      actionWidgetBuilder: (order, total) {
        return Column(
          children: [
            // Nút báo cáo đơn hàng
            OutlinedButton(
              onPressed: () {
                // Chuyển đến trang báo cáo đơn hàng và truyền thông tin cần thiết
                Get.toNamed(
                  '/send-report', // Đảm bảo bạn đã định nghĩa route này trong GetX
                  arguments: {
                    'typeId': 4, // 4 là ID loại báo cáo cho Đơn hàng
                    'itemId': order.id,
                    'itemName': 'Đơn hàng ${order.id}', // Hoặc tên sản phẩm nếu có
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blueAccent, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Báo cáo đơn hàng",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
