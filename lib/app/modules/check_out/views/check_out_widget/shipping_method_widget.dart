

import 'package:flutter/material.dart';
import '../../../../models/order.dart';

class ShippingMethodWidget extends StatelessWidget {
  final Order order;
  const ShippingMethodWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hiển thị phương thức vận chuyển mặc định
    String shippingMethod = "Shop ship (0 đồng)";
    return Row(
      children: [
        const Icon(Icons.delivery_dining, size: 25),
        const SizedBox(width: 6),
        Text(
          shippingMethod,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}


