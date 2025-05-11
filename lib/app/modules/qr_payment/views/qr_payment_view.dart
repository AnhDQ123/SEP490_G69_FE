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
    final qrSize = screenWidth * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(212, 163, 115, 1), Colors.green.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(212, 163, 115, 1)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Đang tải thông tin thanh toán...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Quét mã QR để thanh toán",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(212, 163, 115, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                /// QR Code hiển thị trong Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  shadowColor: Colors.green.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (controller.qrImageUrl.value.startsWith('data:image'))
                          GestureDetector(
                            onTap: () {
                              final base64String =
                                  controller.qrImageUrl.value.split(',').last;
                              final bytes =
                              Uint8List.fromList(base64Decode(base64String));
                              Get.dialog(
                                Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.all(40),
                                  child: InteractiveViewer(
                                    child: Image.memory(bytes,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              );
                            },
                            child: Builder(
                              builder: (_) {
                                final base64String =
                                    controller.qrImageUrl.value.split(',').last;
                                final bytes = Uint8List.fromList(
                                    base64Decode(base64String));
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.green.shade100,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.memory(
                                    bytes,
                                    width: qrSize,
                                    height: qrSize,
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Column(
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: Colors.red),
                              const SizedBox(height: 8),
                              Text(
                                "Không thể tải mã QR",
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Các nút chức năng
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        icon: Icons.share,
                        label: "Chia sẻ",
                        color: Colors.blue,
                        onTap: () =>
                            _shareQrImage(controller.qrImageUrl.value),
                      ),
                      const SizedBox(width: 20),
                      _buildActionButton(
                        icon: Icons.image,
                        label: "Tải ảnh",
                        color: Colors.orange,
                        onTap: controller.pickAndUploadProof,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                /// Ảnh bằng chứng đã gửi
                GetBuilder<QrPaymentController>(
                  builder: (_) {
                    if (_.order.paymentProof?.isNotEmpty ?? false) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "ẢNH ĐÃ GỬI",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(212, 163, 115, 1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: InteractiveViewer(
                                    child: Image.network(
                                      _.order.paymentProof!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.network(
                                  _.order.paymentProof!,
                                  width: screenWidth * 0.8,
                                  height: screenWidth * 0.8,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Nhấn vào ảnh để xem chi tiết",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
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
      ),

      /// Nút xác nhận thanh toán ở đáy
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: controller.confirmPaymentAndNotify,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(55),
              backgroundColor: Color.fromRGBO(212, 163, 115, 1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
              shadowColor: Colors.green.shade200,
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 24),
                SizedBox(width: 10),
                Text("XÁC NHẬN ĐÃ THANH TOÁN"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}