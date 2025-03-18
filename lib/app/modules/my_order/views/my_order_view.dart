// import 'package:ffb_fe_flutter/app/modules/my_order/views/status_widget/canceled_order_widget.dart';
// import 'package:ffb_fe_flutter/app/modules/my_order/views/status_widget/delivered_order_widget.dart';
// import 'package:ffb_fe_flutter/app/modules/my_order/views/status_widget/pending_order_widget.dart';
// import 'package:ffb_fe_flutter/app/modules/my_order/views/status_widget/preparing_order_widget.dart';
// import 'package:ffb_fe_flutter/app/modules/my_order/views/status_widget/returned_order_widget.dart';
// import 'package:ffb_fe_flutter/app/modules/my_order/views/status_widget/shipping_order_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../resources/bottom_nav.dart';
// import '../controllers/my_order_controller.dart';
// import 'order_tab_bar.dart';
//
// class MyOrderView extends GetView<MyOrderController> {
//   const MyOrderView({Key? key}) : super(key: key);
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Chờ xác nhận":
//         return Colors.orange;
//       case "Đang chuẩn bị":
//         return Colors.blue;
//       case "Đang giao":
//         return Colors.purple;
//       case "Đã giao":
//         return Colors.green;
//       case "Đã huỷ":
//         return Colors.red;
//       case "Đã trả":
//         return Colors.blueAccent;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final MyOrderController controller = Get.find<MyOrderController>();
//
//     return DefaultTabController(
//       length: 6,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Get.back(),
//           ),
//           // Icon trước tiêu đề và các action ở bên phải
//           title: Row(
//             children: const [
//               Icon(Icons.shopping_bag, size: 20),
//               SizedBox(width: 8),
//               Text("Đơn hàng của bạn", style: TextStyle(fontSize: 14)),
//             ],
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: InkWell(
//                 onTap: () {
//                   // TODO: Xử lý tìm kiếm
//                 },
//                 child: Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: const Color.fromRGBO(212, 163, 115, 1), width: 1.5),
//                   ),
//                   child: Icon(
//                     Icons.search,
//                     color: const Color.fromRGBO(212, 163, 115, 1),
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: InkWell(
//                 onTap: () {
//                   // TODO: Xử lý tin nhắn
//                 },
//                 child: Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: const Color.fromRGBO(212, 163, 115, 1), width: 1.5),
//                   ),
//                   child: Icon(
//                     Icons.message,
//                     color: const Color.fromRGBO(212, 163, 115, 1),
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(30),
//             child: TabBar(
//               isScrollable: true,
//               labelPadding: const EdgeInsets.symmetric(horizontal: 8),
//               // Điều chỉnh phần tử đầu tiên không có padding bên trái
//               tabs: List.generate(
//                 6,
//                     (index) {
//                   final tabs = ["Chờ xác nhận", "Đang chuẩn bị", "Đang giao", "Đã giao", "Đã huỷ", "Đã trả"];
//                   return index == 0
//                       ? Padding(
//                     padding: const EdgeInsets.only(left: 0, right: 8),
//                     child: Tab(text: tabs[index]),
//                   )
//                       : Tab(text: tabs[index]);
//                 },
//               ),
//               labelStyle: const TextStyle(fontSize: 10),
//               unselectedLabelStyle: const TextStyle(fontSize: 10),
//               labelColor: const Color.fromRGBO(212, 163, 115, 1),
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: const Color.fromRGBO(212, 163, 115, 1),
//             ),
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             PendingOrderWidget(
//               orders: controller.pendingConfirmationOrders,
//               getStatusColor: _getStatusColor,
//             ),
//             PreparingOrderWidget(
//               orders: controller.preparingOrders,
//               getStatusColor: _getStatusColor,
//             ),
//             ShippingOrderWidget(
//               orders: controller.shippingOrders,
//               getStatusColor: _getStatusColor,
//             ),
//             DeliveredOrderWidget(
//               orders: controller.deliveredOrders,
//               getStatusColor: _getStatusColor,
//             ),
//             CanceledOrderWidget(
//               orders: controller.canceledOrders,
//               getStatusColor: _getStatusColor,
//             ),
//             ReturnedOrderWidget( // thêm tab "Đã trả"
//               orders: controller.returnedOrders,
//               getStatusColor: _getStatusColor,
//             ),
//           ],
//         ),
//         bottomNavigationBar: Obx(
//               () => BottomNav(
//             currentIndex: controller.currentIndex.value,
//             onItemSelected: controller.changeTabIndex,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/bottom_nav.dart';
import '../controllers/my_order_controller.dart';
import 'order_tab_bar.dart';
import 'status_widget/canceled_order_widget.dart';
import 'status_widget/delivered_order_widget.dart';
import 'status_widget/pending_order_widget.dart';
import 'status_widget/preparing_order_widget.dart';
import 'status_widget/returned_order_widget.dart';
import 'status_widget/shipping_order_widget.dart';

class MyOrderView extends GetView<MyOrderController> {
  const MyOrderView({Key? key}) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case "Chờ xác nhận":
        return Colors.orange;
      case "Đang chuẩn bị":
        return Colors.blue;
      case "Đang giao":
        return Colors.purple;
      case "Đã giao":
        return Colors.green;
      case "Đã huỷ":
        return Colors.red;
      case "Đã trả":
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MyOrderController controller = Get.find<MyOrderController>();

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: const Text("Đơn hàng của bạn"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: TabBar(
              isScrollable: true,
              tabs: const [
                Tab(text: "Chờ xác nhận"),
                Tab(text: "Đang chuẩn bị"),
                Tab(text: "Đang giao"),
                Tab(text: "Đã giao"),
                Tab(text: "Đã huỷ"),
                Tab(text: "Đã trả"),
              ],
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator()); // Hiển thị loading khi đang tải dữ liệu
          }

          if (controller.pendingOrders.isEmpty &&
              controller.preparingOrders.isEmpty &&
              controller.shippingOrders.isEmpty &&
              controller.deliveredOrders.isEmpty &&
              controller.canceledOrders.isEmpty &&
              controller.returnedOrders.isEmpty) {
            return const Center(
              child: Text("Không có đơn hàng nào!"),
            ); // Nếu không có đơn hàng, hiển thị thông báo
          }

          return TabBarView(
            children: [
              PendingOrderWidget(
                orders: controller.pendingOrders,
                getStatusColor: _getStatusColor,
              ),
              PreparingOrderWidget(
                orders: controller.preparingOrders,
                getStatusColor: _getStatusColor,
              ),
              ShippingOrderWidget(
                orders: controller.shippingOrders,
                getStatusColor: _getStatusColor,
              ),
              DeliveredOrderWidget(
                orders: controller.deliveredOrders,
                getStatusColor: _getStatusColor,
              ),
              CanceledOrderWidget(
                orders: controller.canceledOrders,
                getStatusColor: _getStatusColor,
              ),
              ReturnedOrderWidget(
                orders: controller.returnedOrders,
                getStatusColor: _getStatusColor,
              ),
            ],
          );
        }),

        bottomNavigationBar: Obx(
              () => BottomNav(
            currentIndex: controller.currentIndex.value,
            onItemSelected: controller.changeTabIndex,
          ),
        ),
      ),
    );
  }
}

