import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/bottom_nav.dart';
import '../../shop_order/views/shop_status_widget/shop_rejected_order_widget.dart';
import '../controllers/my_order_controller.dart';
import 'order_tab_bar.dart';
import 'status_widget/canceled_order_widget.dart';
import 'status_widget/delivered_order_widget.dart';
import 'status_widget/pending_order_widget.dart';
import 'status_widget/preparing_order_widget.dart';
import 'status_widget/returned_order_widget.dart';
import 'status_widget/shipping_order_widget.dart';
import 'status_widget/return_pending_order_widget.dart'; // ✅ MỚI

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
      case "Đang trả hàng":
      case "RETURN_PENDING":
        return Colors.blueAccent;
      case "Đã trả hàng":
      case "RETURNED":
        return Colors.green;
      case "Bị từ chối":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MyOrderController controller = Get.find<MyOrderController>();

    return DefaultTabController(
      length: 8, // ✅ Đã tăng từ 7 lên 8
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
                Tab(text: "Đang trả hàng"), // ✅ Mới
                Tab(text: "Đã trả hàng"),   // ✅ Mới
                Tab(text: "Bị từ chối"),
              ],
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.pendingOrders.isEmpty &&
              controller.preparingOrders.isEmpty &&
              controller.shippingOrders.isEmpty &&
              controller.deliveredOrders.isEmpty &&
              controller.canceledOrders.isEmpty &&
              controller.returnPendingOrders.isEmpty && // ✅ Thêm check
              controller.returnedOrders.isEmpty &&
              controller.rejectedOrders.isEmpty) {
            return const Center(
              child: Text("Không có đơn hàng nào!"),
            );
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
              ReturnPendingOrderWidget( // ✅ Tab "Đang trả hàng"
                orders: controller.returnPendingOrders,
                getStatusColor: _getStatusColor,
              ),
              ReturnedOrderWidget( // ✅ Tab "Đã trả hàng"
                orders: controller.returnedOrders,
                getStatusColor: _getStatusColor,
              ),
              RejectedOrderWidget(
                orders: controller.rejectedOrders,
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
