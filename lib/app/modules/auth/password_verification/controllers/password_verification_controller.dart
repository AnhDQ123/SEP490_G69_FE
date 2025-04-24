import 'package:ffb_fe_flutter/app/service/register_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_common.dart';
import '../../../../resources/snackbar.dart';
import '../../../../resources/validate.dart';

class PasswordVerificationController extends GetxController {
  var phoneNumber = ''.obs;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final RegisterService registerService = RegisterService();

  // Biến quan sát lưu lỗi cho email, mật khẩu và xác nhận mật khẩu
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;

  // Biến quan sát quản lý trạng thái ẩn/hiện mật khẩu
  final isPasswordObscured = true.obs;
  final isConfirmPasswordObscured = true.obs;

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments?['phone'] ?? 'Unknown';
  }

  void submitUserData() async {
    final phone = phoneNumber.value.trim();
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Kiểm tra email, mật khẩu và xác nhận mật khẩu trước khi submit
    String? emailErr = Validate.validateEmail(email);
    if (emailErr != null) {
      emailError.value = emailErr;
      CustomSnackbar.showError(emailErr);
      return;
    } else {
      emailError.value = '';
    }

    String? passErr = Validate.validatePassword(password);
    String? confirmPassErr = Validate.validatePassword(confirmPassword, confirmPassword: password);
    if (passErr != null) {
      passwordError.value = passErr;
      CustomSnackbar.showError(passErr);
      return;
    } else {
      passwordError.value = '';
    }
    if (confirmPassErr != null) {
      confirmPasswordError.value = confirmPassErr;
      CustomSnackbar.showError(confirmPassErr);
      return;
    } else {
      confirmPasswordError.value = '';
    }

    isLoading(true);
    final response = await registerService.registerUser(phone, email, password);

    if (response['success'] == true) {
      CustomSnackbar.showSuccess(response['message']);
      Get.toNamed('/user-info', arguments: {
        'phone': phone,
        'email' : email,     //  ← thêm
        'user_id': response['user_id'] ?? '' // Truyền cả phone và user_id nếu có
      });
    } else {
      CustomSnackbar.showError(response['message']);
    }
    isLoading(false);
  }
}


