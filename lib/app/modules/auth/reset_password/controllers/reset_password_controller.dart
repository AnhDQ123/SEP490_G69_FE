import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/snackbar.dart';
import '../../../../resources/validate.dart';
import '../../../../routes/app_pages.dart';
import '../../../../service/register_service.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final phone = ''.obs;
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;

  final _service = RegisterService();

  @override
  void onInit() {
    super.onInit();
    phone.value = Get.arguments['phone'] ?? '';
  }

  void togglePasswordVisibility() => showPassword.toggle();
  void toggleConfirmPasswordVisibility() => showConfirmPassword.toggle();

  void submit() async {
    final pw = newPasswordController.text.trim();
    final cpw = confirmPasswordController.text.trim();

    final err = Validate.validatePassword(pw);
    if (err != null) {
      CustomSnackbar.showError(err);
      return;
    }
    if (pw != cpw) {
      CustomSnackbar.showError('Mật khẩu nhập lại không khớp');
      return;
    }

    isLoading(true);
    try {
      final res = await _service.forgotPassword(
        phone: phone.value,
        password: pw,
        confirmPassword: cpw,
      );

      if (res['success'] == true) {
        CustomSnackbar.showSuccess(res['message']);
        Get.offAllNamed(Routes.LOGIN);
      } else {
        CustomSnackbar.showError(res['message']);
      }
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}