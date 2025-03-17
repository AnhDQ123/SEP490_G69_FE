import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/check_out_controller.dart';

class ShippingMethodWidget extends StatelessWidget {
  ShippingMethodWidget({Key? key}) : super(key: key);

  final CheckOutController controller = Get.find<CheckOutController>();

  void _showShippingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.storefront, size: 18),
              title: const Text(
                "Shop tự ship (0 đồng)",
                style: TextStyle(fontSize: 10),
              ),
              onTap: () {
                Navigator.pop(context); // Đóng bottom sheet
                // Hiển thị cảnh báo khi chọn Shop tự ship
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Lưu ý", style: TextStyle(fontSize: 12)),
                    content: const Text(
                      "Nếu shop tự ship thì có thể sẽ lâu vì thiếu nhân lực.",
                      style: TextStyle(fontSize: 10),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Đã hiểu", style: TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                );
                controller.updateShippingMethod("Shop tự ship (0 đồng)");
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping, size: 18),
              title: const Text(
                "Shipper (10,000 đồng)",
                style: TextStyle(fontSize: 10),
              ),
              onTap: () {
                Navigator.pop(context); // Đóng bottom sheet
                controller.updateShippingMethod("Shipper (10,000 đồng)");
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showShippingOptions(context),
      child: Obx(() => Row(
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            size: 18,
            color: Colors.black54,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              controller.checkoutInfo.value.shippingMethod.isEmpty
                  ? "Chọn phương pháp vận chuyển"
                  : controller.checkoutInfo.value.shippingMethod,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
