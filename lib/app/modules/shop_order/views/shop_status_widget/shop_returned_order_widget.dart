// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../../../models/order.dart';
// import '../../../my_order/views/order_list_widget.dart';
//
// class ShopReturnedOrderWidget extends StatelessWidget {
//   final List<Order> orders;
//   final Color Function(String) getStatusColor;
//
//   const ShopReturnedOrderWidget({
//     Key? key,
//     required this.orders,
//     required this.getStatusColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return OrderListWidget(
//       orders: orders,
//       status: "Đã trả",
//       getStatusColor: getStatusColor,
//       isShopView: true, // ✅ ẩn tên shop, chỉ hiện ID đơn
//       actionWidgetBuilder: (order, total) {
//         return OutlinedButton(
//           onPressed: () {
//             Get.toNamed('/return-qr', arguments: {
//               'orderId': order.id,
//               'userId': order.ownerId,
//             });
//           },
//           style: OutlinedButton.styleFrom(
//             side: const BorderSide(color: Colors.green, width: 1.5),
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//           child: const Text(
//             "Xem chi tiết",
//             style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.green),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/order.dart';
import '../../controllers/shop_order_controller.dart';
import '../../../my_order/views/order_list_widget.dart';

class ShopReturnedOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopReturnedOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShopOrderController>(); // 🔹 Lấy controller

    return OrderListWidget(
      orders: orders,
      status: "Đã trả",
      getStatusColor: getStatusColor,
      isShopView: true, // ✅ ẩn tên shop, chỉ hiện ID đơn
      actionWidgetBuilder: (order, total) {
        return Obx(() {
          // 🔍 Nếu đơn hàng đã quét mã → ẩn nút
          if (controller.scannedOrderIds.contains(order.id)) {
            return const SizedBox.shrink();
          }

          return OutlinedButton(
            onPressed: () async {
              final result = await Get.toNamed('/return-qr', arguments: {
                'orderId': order.id,
                'userId': order.ownerId,
              });

              if (result == true) {
                controller.scannedOrderIds.add(order.id); // ✅ Đánh dấu đã quét
                Get.snackbar("✅ Thành công", "Mã QR đã được sử dụng");
              }
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.green, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              "Tạo mã QR",
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          );
        });
      },
    );
  }
}

