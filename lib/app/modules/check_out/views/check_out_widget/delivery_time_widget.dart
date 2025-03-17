import 'package:flutter/material.dart';
import '../../../../models/check_out.dart';

class DeliveryTimeWidget extends StatelessWidget {
  final CheckoutInfo checkout;
  const DeliveryTimeWidget({Key? key, required this.checkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeStr = (checkout.deliveryTime != null)
        ? "${checkout.deliveryTime!.hour}:${checkout.deliveryTime!.minute.toString().padLeft(2, '0')} - ${checkout.deliveryTime!.day}/${checkout.deliveryTime!.month}"
        : "Chưa xác định";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.schedule, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(child: Text("Thời gian giao dự kiến: $timeStr", style: const TextStyle(fontSize: 10))),
      ],
    );
  }
}
