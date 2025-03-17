import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/check_out.dart';
import '../../controllers/check_out_controller.dart';

class ExtraToolWidget extends StatelessWidget {
  final CheckoutInfo checkout;
  const ExtraToolWidget({Key? key, required this.checkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckOutController>();
    return Row(
      children: [
        const Icon(Icons.restaurant, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        const Text("Thêm dụng cụ ăn uống", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
        const Spacer(),
        Switch(
          value: checkout.needTools,
          onChanged: (val) {
            controller.toggleNeedTools(val);
          },
        ),
      ],
    );
  }
}
