import 'package:ffb_fe_flutter/app/modules/check_out/views/check_out_widget/voucher_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/order.dart';
import '../../controllers/check_out_controller.dart';

class VoucherSectionWidget extends StatelessWidget {
  final Order order;
  const VoucherSectionWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckOutController>();

    return InkWell(
      onTap: () => _showVoucherBottomSheet(context, controller),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer, color: Colors.black),
            const SizedBox(width: 8),
            if (order.voucherId != null && order.voucherAmount > 0)
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
                      text: "- ${(order.voucherAmount * 100).toInt()}%",
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              )
            else
              const Text(
                "Chọn hoặc nhập voucher",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void _showVoucherBottomSheet(BuildContext context, CheckOutController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => VoucherBottomSheet(controller: controller),
    );
  }
}

