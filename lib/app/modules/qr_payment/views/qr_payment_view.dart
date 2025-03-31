import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../controllers/qr_payment_controller.dart';

class QrPaymentView extends GetView<QrPaymentController> {
  const QrPaymentView({Key? key}) : super(key: key);

  Future<void> _saveQrImage(String imageUrl) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      Get.snackbar("Lỗi", "Không có quyền lưu ảnh");
      return;
    }
  }

  Future<void> _shareQrImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final tempPath = '${(await getTemporaryDirectory()).path}/qr_temp.png';
      final file = await File(tempPath).writeAsBytes(response.bodyBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Mã QR thanh toán của tôi');
    } catch (e) {
      Get.snackbar("Lỗi", "Chia sẻ thất bại: $e");
    }
  }

  Future<void> _pickProofImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      Get.snackbar("✔️ Đã chọn ảnh", picked.name);
    } else {
      Get.snackbar("Huỷ", "Bạn chưa chọn ảnh nào");
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    final order = controller.order;
    final screenWidth = MediaQuery.of(context).size.width;
    final qrSize = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán bằng VietQR")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Quét mã QR để thanh toán",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),

                if (controller.qrImageUrl.value.startsWith('data:image'))
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        final base64String = controller.qrImageUrl.value.split(',').last;
                        final bytes = Uint8List.fromList(base64Decode(base64String));
                        Get.dialog(Dialog(
                          backgroundColor: Colors.transparent,
                          child: InteractiveViewer(
                            child: Image.memory(bytes, fit: BoxFit.contain),
                          ),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Builder(
                          builder: (_) {
                            final base64String = controller.qrImageUrl.value.split(',').last;
                            final bytes = Uint8List.fromList(base64Decode(base64String));
                            return Image.memory(
                              bytes,
                              width: qrSize,
                              height: qrSize,
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      ),
                    ),
                  )
                else
                  const Icon(Icons.error, size: 48),

                const SizedBox(height: 32),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text("Chia sẻ QR"),
                      onPressed: () => _shareQrImage(controller.qrImageUrl.value),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text("Tải ảnh bằng chứng"),
                      onPressed: controller.pickAndUploadProof,
                    ),
                    if (controller.order.paymentProof?.isNotEmpty ?? false)
                      Column(
                        children: [
                          const SizedBox(height: 24),
                          const Text("📸 Ảnh đã gửi", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              controller.order.paymentProof!,
                              width: screenWidth * 0.7,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),

                  ],
                ),

                const SizedBox(height: 32),

                ElevatedButton.icon(
                  onPressed: controller.confirmPaymentAndNotify,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Tôi đã thanh toán"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
