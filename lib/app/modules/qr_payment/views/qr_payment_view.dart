import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/qr_payment_controller.dart';

class QrPaymentView extends GetView<QrPaymentController> {
  const QrPaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = controller.order;

    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán bằng VietQR")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Quét mã QR để thanh toán", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              QrImageView(
                data: controller.qrCode.value,
                version: QrVersions.auto,
                size: 220,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed('/my-order', arguments: order);
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Tôi đã thanh toán"),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              ),
            ],
          ),
        );
      }),
    );
  }
}
