import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/check_out_controller.dart';
import 'check_out_widget/address_section_widget.dart';
import 'check_out_widget/cost_summary_widget.dart';
import 'check_out_widget/delivery_time_widget.dart';
import 'check_out_widget/disclaimer_widget.dart';
import 'check_out_widget/extra_tool_widget.dart';
import 'check_out_widget/note_widget.dart';
import 'check_out_widget/order_items_section_widget.dart';
import 'check_out_widget/payment_method_widget.dart';
import 'check_out_widget/shipping_method_widget.dart';
import 'check_out_widget/voucher_section_widget.dart';


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
        final checkout = controller.checkoutInfo.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              AddressSectionWidget(checkout: checkout),
              const SizedBox(height: 12),
              DeliveryTimeWidget(checkout: checkout),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1),
              OrderItemsSectionWidget(checkout: checkout),
              const Divider(height: 1, thickness: 1),
              VoucherSectionWidget(checkout: checkout),
              const SizedBox(height: 12),
               ShippingMethodWidget(),
              const SizedBox(height: 12),
              ExtraToolWidget(checkout: checkout),
              const SizedBox(height: 12),
              NoteWidget(checkout: checkout),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1),
              CostSummaryWidget(checkout: checkout),
              const SizedBox(height: 12),
              PaymentMethodWidget(checkout: checkout),
              const SizedBox(height: 12),
              const DisclaimerWidget(),
              const SizedBox(height: 12),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await controller.placeOrder();
              // TODO: Xử lý chuyển trang hoặc thông báo thành công
            },
            child: const Text("Đặt hàng", style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
