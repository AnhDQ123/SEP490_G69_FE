import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../controllers/qr_payment_controller.dart';

class QrPaymentView extends GetView<QrPaymentController> {
  const QrPaymentView({Key? key}) : super(key: key);

  Future<void> _shareQrImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final tempPath = '${(await getTemporaryDirectory()).path}/qr_temp.png';
      final file = await File(tempPath).writeAsBytes(response.bodyBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Mã QR thanh toán');
    } catch (e) {
      Get.snackbar("Lỗi", "Chia sẻ thất bại: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    final screenWidth = MediaQuery.of(context).size.width;
    final qrSize = screenWidth * 0.5;

    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Quét mã QR để thanh toán",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              /// QR Code hiển thị trong Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: controller.qrImageUrl.value.startsWith('data:image')
                      ? GestureDetector(
                    onTap: () {
                      final base64String =
                          controller.qrImageUrl.value.split(',').last;
                      final bytes = Uint8List.fromList(base64Decode(base64String));
                      Get.dialog(Dialog(
                        backgroundColor: Colors.transparent,
                        child: InteractiveViewer(
                          child: Image.memory(bytes, fit: BoxFit.contain),
                        ),
                      ));
                    },
                    child: Builder(
                      builder: (_) {
                        final base64String =
                            controller.qrImageUrl.value.split(',').last;
                        final bytes =
                        Uint8List.fromList(base64Decode(base64String));
                        return Image.memory(
                          bytes,
                          width: qrSize,
                          height: qrSize,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  )
                      : const Icon(Icons.error, size: 48),
                ),
              ),

              const SizedBox(height: 12),

              /// Các nút chức năng: chia sẻ + tải ảnh
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: "Chia sẻ mã QR",
                    icon: const Icon(Icons.share),
                    onPressed: () => _shareQrImage(controller.qrImageUrl.value),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: "Tải ảnh bằng chứng",
                    icon: const Icon(Icons.image),
                    onPressed: controller.pickAndUploadProof,
                  ),
                ],
              ),


              const SizedBox(height: 24),

              /// Ảnh bằng chứng đã gửi
              GetBuilder<QrPaymentController>(
                builder: (_) {
                  if (_.order.paymentProof?.isNotEmpty ?? false) {
                    return Column(
                      children: [
                        const Text(
                          "📸 Ảnh đã gửi",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            _.order.paymentProof!,
                            width: screenWidth * 0.7,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      }),

      /// Nút xác nhận thanh toán ở đáy
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: controller.confirmPaymentAndNotify,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text("Tôi đã thanh toán"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
