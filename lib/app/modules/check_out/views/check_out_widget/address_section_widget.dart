import 'package:flutter/material.dart';
import '../../../../models/order.dart';

class AddressSectionWidget extends StatelessWidget {
  final Order order;
  const AddressSectionWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, size: 16, color: Colors.black54),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Địa chỉ giao hàng",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                order.address,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
