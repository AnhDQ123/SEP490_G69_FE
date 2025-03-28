import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/order.dart';

class QrPaymentController extends GetxController {
  late Order order;
  var qrCode = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;
    if (arg is Order) {
      order = arg;
      generateQrFromVietQR(); // ✅ phải gọi ở đây!
    } else {
      print("❌ Không nhận được Order hợp lệ trong QrPaymentController");
      Get.back(); // hoặc chuyển hướng lại
    }
  }



  Future<void> generateQrFromVietQR() async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse("https://api.vietqr.io/v2/generate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "accountNo": "123456789", // 👉 thay bằng số tài khoản thật
          "accountName": "NGUYEN VAN A", // 👉 tên tài khoản
          "acqId": "970422", // 👉 mã ngân hàng (ví dụ MB Bank)
          "amount": order.total.toInt(),
          "addInfo": "Thanh toan don hang ${order.id}"
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        qrCode.value = data["data"]["qrCode"]; // ✅ Dùng chuỗi QR để render
      } else {
        Get.snackbar("Lỗi", "Không tạo được mã QR");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không gọi được API VietQR");
    } finally {
      isLoading(false);
    }
  }
}
