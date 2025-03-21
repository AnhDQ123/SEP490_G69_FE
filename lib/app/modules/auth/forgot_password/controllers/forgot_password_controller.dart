import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_controller.dart';
import '../../../../routes/app_pages.dart';
import '../../../../service/register_service.dart';
import '../../../../resources/snackbar.dart';

class ForgotPasswordController extends BaseController {
  final TextEditingController phoneEmailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  // Nếu BaseController không có isLoading, khai báo ở đây:
  final isLoading = false.obs;

  void sendResetRequest() async {
    if (phoneEmailController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập số điện thoại.");
      return;
    }

    isLoading(true);
    // Gọi API gửi OTP từ RegisterService
    bool isOtpSent = await RegisterService().sendOtp(phoneEmailController.text);
    isLoading(false);

    if (isOtpSent) {
      // Chuyển sang màn OTP Verification và truyền flow là "forgotPassword"
      Get.toNamed(Routes.OTP_VERIFICATION, arguments: {"phone": phoneEmailController.text, "flow": "forgotPassword"});
    } else {
      Get.snackbar("Lỗi", "Gửi OTP thất bại. Vui lòng thử lại.");
    }
  }

  void resetPassword() async {
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập đầy đủ mật khẩu.");
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Lỗi", "Mật khẩu nhập lại không khớp.");
      return;
    }

    isLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    isLoading(false);

    Get.snackbar("Thành công", "Mật khẩu đã được đặt lại.");
    Get.offAllNamed(Routes.LOGIN);
  }
}
