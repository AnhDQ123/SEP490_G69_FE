import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../models/order.dart';
import '../../../service/notification_service.dart';
import '../../../service/order_service.dart';

class QrPaymentController extends GetxController {
  late Order order;
  var qrImageUrl = ''.obs;
  var isLoading = true.obs;
  final OrderService _orderService = OrderService();


  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;
    if (arg is Order) {
      order = arg;
      generateQrFromBackend();
    } else {
      print("❌ Không nhận được Order hợp lệ trong QrPaymentController");
      Get.back();
    }
  }

  Future<void> generateQrFromBackend() async {
    try {
      isLoading(true);
      final qr = await _orderService.generateQrCode(order.id, order.shopId);
      if (qr != null) {
        qrImageUrl.value = qr;
      } else {
        Get.snackbar("Lỗi", "Không tạo được mã QR từ backend");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể gọi API: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickAndUploadProof() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      try {
        Get.snackbar("🔄 Đang gửi", "Đang upload bằng chứng thanh toán...");
        final file = File(picked.path);
        await _orderService.uploadPaymentProof(order.id!, file);

        // Gọi lại API lấy đơn hàng mới nhất (có paymentProof)
        final updatedOrder = await _orderService.fetchOrderById(order.id!);
        if (updatedOrder != null) {
          order = updatedOrder;
          update(); // Cập nhật UI nếu cần
          log("🖼️ New paymentProof: ${order.paymentProof}");

        }

        Get.snackbar("✅ Thành công", "Đã gửi ảnh bằng chứng thanh toán!");
      } catch (e) {
        Get.snackbar("❌ Lỗi", "Không gửi được: $e");
      }
    } else {
      Get.snackbar("Huỷ", "Bạn chưa chọn ảnh nào");
    }
  }

  Future<void> confirmPaymentAndNotify() async {
    try {
      log("🟡 Bắt đầu xác nhận thanh toán");

      await NotificationService.showOrderSuccessNotification(
          "Bạn đã xác nhận thanh toán đơn #${order.id ?? order.id}"
      );

      log("✅ Đã gọi NotificationService thành công, chuyển trang...");
      Get.toNamed('/my-order', arguments: order.ownerId);
    } catch (e) {
      log("❌ Lỗi trong confirmPaymentAndNotify: $e");
      Get.snackbar("Lỗi", "Không thể xác nhận thanh toán: $e");
    }
  }




}
