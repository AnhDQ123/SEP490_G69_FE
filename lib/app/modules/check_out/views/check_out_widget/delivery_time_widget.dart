import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/order.dart';

class DeliveryTimeWidget extends StatelessWidget {
  final Order order;
  const DeliveryTimeWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Nếu Order có trường deliveryTime thì sử dụng nó, nếu không thì giả sử là createdAt + 2 giờ
    final deliveryTime = order.createdAt?.add(const Duration(hours: 2));
    final timeStr = DateFormat('HH:mm, dd/MM').format(deliveryTime!);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.schedule, size: 16, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "Thời gian giao dự kiến: $timeStr",
            style: const TextStyle(fontSize: 10, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
