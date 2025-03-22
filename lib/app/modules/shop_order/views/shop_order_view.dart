import 'package:ffb_fe_flutter/app/modules/shop_order/views/shop_status_widget/shop_canceled_order_widget.dart';
import 'package:ffb_fe_flutter/app/modules/shop_order/views/shop_status_widget/shop_delivered_order_widget.dart';
import 'package:ffb_fe_flutter/app/modules/shop_order/views/shop_status_widget/shop_pending_order_widget.dart';
import 'package:ffb_fe_flutter/app/modules/shop_order/views/shop_status_widget/shop_preparing_order_widget.dart';
import 'package:ffb_fe_flutter/app/modules/shop_order/views/shop_status_widget/shop_rejected_order_widget.dart';
import 'package:ffb_fe_flutter/app/modules/shop_order/views/shop_status_widget/shop_return_pending_order_widget.dart';
import 'package:ffb_fe_flutter/app/modules/shop_order/views/shop_status_widget/shop_return_rejected_order_widget.dart';
import 'package:ffb_fe_flutter/app/modules/shop_order/views/shop_status_widget/shop_returned_order_widget.dart';
import 'package:ffb_fe_flutter/app/modules/shop_order/views/shop_status_widget/shop_shipping_order_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../my_order/views/order_tab_bar.dart';
import '../../my_order/views/status_widget/canceled_order_widget.dart';
import '../../my_order/views/status_widget/delivered_order_widget.dart';
import '../../my_order/views/status_widget/returned_order_widget.dart';
import '../controllers/shop_order_controller.dart';

class ShopOrderView extends GetView<ShopOrderController> {
  const ShopOrderView({super.key});

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
      case "Đã từ chối":
        return Colors.grey;
      case "Từ chối trả":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShopOrderController>();
    final tabs = const [
      "Chờ xác nhận",
      "Đang chuẩn bị",
      "Đang giao",
      "Đã giao",
      "Đã huỷ",
      "Chờ xử lý trả",
      "Đã trả",
      "Đã từ chối",
      "Từ chối trả",
    ];


    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Đơn hàng cửa hàng"),
          bottom: OrderTabBar(tabs: tabs),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              ShopPendingOrderWidget(
                orders: controller.pending,
                getStatusColor: _getStatusColor,
              ),
              ShopPreparingOrderWidget(
                orders: controller.processing,
                getStatusColor: _getStatusColor,
              ),
              ShopShippingOrderWidget(
                orders: controller.shipping,
                getStatusColor: _getStatusColor,
              ),

              ShopDeliveredOrderWidget(
                orders: controller.delivered,
                getStatusColor: _getStatusColor,
              ),
              ShopCanceledOrderWidget(
                orders: controller.cancelled,
                getStatusColor: _getStatusColor,
              ),
              ShopReturnPendingOrderWidget(
                orders: controller.returnPending,
                getStatusColor: _getStatusColor,
              ),
              ShopReturnedOrderWidget(
                orders: controller.returned,
                getStatusColor: _getStatusColor,
              ),
              RejectedOrderWidget(
                orders: controller.rejected,
                getStatusColor: _getStatusColor,
              ),
              ShopReturnRejectedOrderWidget(
                orders: controller.returnRejected,
                getStatusColor: _getStatusColor,
              ),

            ],
          );
        }),
      ),
    );
  }
}
