import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_controller.dart';
import '../../../../resources/snackbar.dart';
import '../../../../resources/validate.dart';
import '../../../../service/register_service.dart';

class RegisterController extends BaseController {
  final phoneController = TextEditingController();
  final errorMessage = ''.obs;
  final isLoading = false.obs;
  final _registerService = RegisterService();

  void nextStep() async {
    final phone = phoneController.text.trim();
    final phoneError = Validate.validatePhone(phone);

    if (phoneError != null) {
      CustomSnackbar.showWarning(phoneError);
      return;
    }

    isLoading(true);
    bool isOtpSent = await _registerService.sendOtp(phone);
    isLoading(false);

    // if (isOtpSent) {
    //   CustomSnackbar.showSuccess("Mã OTP đã được gửi!");
    //   Get.toNamed('/otp-verification', arguments: {"phone": phone});
    // } else {
    //   CustomSnackbar.showError("Gửi OTP thất bại. Vui lòng thử lại.");
    // }

    if (isOtpSent) {
      CustomSnackbar.showSuccess("Mã OTP đã được gửi!");
      // Thêm "flow": "register"
      Get.toNamed('/otp-verification', arguments: {"phone": phone, "flow": "register"});
    } else {
      CustomSnackbar.showError("Gửi OTP thất bại. Vui lòng thử lại.");
    }
  }

}