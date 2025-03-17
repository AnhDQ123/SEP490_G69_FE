import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/check_out.dart';
import '../../controllers/check_out_controller.dart';

class PaymentMethodWidget extends StatelessWidget {
  final CheckoutInfo checkout;
  const PaymentMethodWidget({Key? key, required this.checkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckOutController>();
    return Row(
      children: [
        const Icon(Icons.account_balance_wallet_outlined, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            "Phương thức thanh toán",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
        OutlinedButton(
          onPressed: () => controller.updatePaymentMethod(PaymentMethod.bank),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: checkout.paymentMethod == PaymentMethod.bank ? Colors.blue : Colors.grey,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Ngân hàng", style: TextStyle(fontSize: 10)),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => controller.updatePaymentMethod(PaymentMethod.cod),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: checkout.paymentMethod == PaymentMethod.cod ? Colors.blue : Colors.grey,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Trực tiếp", style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}
