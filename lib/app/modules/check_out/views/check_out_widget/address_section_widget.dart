import 'package:flutter/material.dart';
import '../../../../models/check_out.dart';

class AddressSectionWidget extends StatelessWidget {
  final CheckoutInfo checkout;
  const AddressSectionWidget({Key? key, required this.checkout}) : super(key: key);

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
              // Tiêu đề với màu riêng (ví dụ: màu đen)
              const Text(
                "Địa chỉ giao hàng",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
              ),
              const SizedBox(height: 2),
              // Nội dung với màu khác (ví dụ: màu xám)
              Text(
                "${checkout.userName} | ${checkout.phoneNumber}\n${checkout.address}",
                style: const TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
