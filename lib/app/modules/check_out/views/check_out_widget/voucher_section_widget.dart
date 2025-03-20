

import 'package:flutter/material.dart';
import '../../../../models/order.dart';

class VoucherSectionWidget extends StatelessWidget {
  final Order order;
  const VoucherSectionWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (order.voucherId == null || order.voucherAmount <= 0) {
      return const SizedBox.shrink();
    }
    // Giả sử order.voucherAmount là số phần trăm (ví dụ: 0.20 tương đương 20%)
    final discountPercent = (order.voucherAmount * 100).toInt();
    return Row(
      children: [
        const Icon(Icons.local_offer, color: Colors.black),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            text: "Voucher: ",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: "- ${discountPercent}%",
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



