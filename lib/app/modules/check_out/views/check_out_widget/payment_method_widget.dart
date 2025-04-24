import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../models/order.dart';
import '../../controllers/check_out_controller.dart';

class PaymentMethodWidget extends StatelessWidget {
  final CheckOutController controller;

  const PaymentMethodWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPaymentMethods.value) {
        return const CircularProgressIndicator();
      }

      if (controller.errorMessagePaymentMethods.isNotEmpty) {
        return Text(controller.errorMessagePaymentMethods.value);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Phương thức thanh toán",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Hiển thị danh sách payment methods từ API
          ...controller.paymentMethods.map((method) => ListTile(
            leading: Icon(Icons.payment, color: Colors.grey),
            title: Text(method.name),
            trailing: controller.selectedPaymentMethod.value?.id == method.id
                ? Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () => controller.selectPaymentMethod(method),
          )),
        ],
      );
    });
  }
}
