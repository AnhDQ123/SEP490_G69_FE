
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/check_out_controller.dart';
import 'check_out_widget/address_section_widget.dart';
import 'check_out_widget/delivery_time_widget.dart';
import 'check_out_widget/order_items_section_widget.dart';
import 'check_out_widget/voucher_section_widget.dart';
import 'check_out_widget/shipping_method_widget.dart';
import 'check_out_widget/extra_tool_widget.dart';
import 'check_out_widget/note_widget.dart';
import 'check_out_widget/cost_summary_widget.dart';
import 'check_out_widget/payment_method_widget.dart';
import 'check_out_widget/disclaimer_widget.dart';

class CheckOutView extends GetView<CheckOutController> {
  const CheckOutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const mainColor = Color.fromRGBO(212, 163, 115, 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else if (controller.order.value == null) {
          return const Center(child: Text("Không có đơn hàng nào"));
        } else {
          final order = controller.order.value!;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddressSectionWidget(order: order),
                const SizedBox(height: 12),
                DeliveryTimeWidget(order: order),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1),
                OrderItemsSectionWidget(order: order),
                const Divider(height: 1, thickness: 1),
                VoucherSectionWidget(order: order),
                const SizedBox(height: 12),
                ShippingMethodWidget(order: order),
                const SizedBox(height: 12),
                ExtraToolWidget(order: order),
                const SizedBox(height: 12),
                NoteWidget(order: order),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1),
                CostSummaryWidget(order: order),
                const SizedBox(height: 12),
                PaymentMethodWidget(order: order),
                const SizedBox(height: 12),
                const DisclaimerWidget(),
                const SizedBox(height: 12),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 60,
          child: Obx(() {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // onPressed: controller.isLoading.value || controller.order.value == null
              //     ? null
              //     : () async {
              //   final order = controller.order.value!;
              //   // await controller.placeOrder(order);
              //   Get.toNamed('/qr-payment', arguments: order);
              // },
              // onPressed: controller.isLoading.value || controller.order.value == null
              //     ? null
              //     : () async {
              //   final newOrder = await controller.placeOrder(controller.order.value!);
              //   if (newOrder != null) {
              //     Get.toNamed('/qr-payment', arguments: newOrder); // ✅ truyền đúng order đã có ID
              //   }
              // },
              onPressed: controller.isLoading.value || controller.order.value == null
                  ? null
                  : () {
                final order = controller.order.value!;
                Get.toNamed('/qr-payment', arguments: order); // ✅ dùng lại order đã có sẵn
              },


              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Đặt hàng", style: TextStyle(fontSize: 16)),
            );
          }),
        ),
      ),
    );
  }

}
