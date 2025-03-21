import 'package:ffb_fe_flutter/app/resources/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_common.dart';
import '../../../../base/base_controller.dart';
import '../../../../routes/app_pages.dart';
import '../../../../service/login_service.dart';

class LoginController extends BaseController {
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final errorMessage = ''.obs;
  final LoginService _loginService = LoginService();

  void login() async {
    final String username = accountController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      CustomSnackbar.showError("Vui lòng nhập tài khoản và mật khẩu.");
      return;
    }

    isLoading(true);

    try {
      final token = await _loginService.login(username: username, password: password);

      if (token != null && token.isNotEmpty) {
        CustomSnackbar.showSuccess("Đăng nhập thành công!");
        BaseCommon.instance.saveToken(token);
        Get.toNamed(Routes.HOME);
      } else {
        CustomSnackbar.showError("Token không hợp lệ hoặc rỗng.");
      }
    } catch (e) {
      CustomSnackbar.showError("Đăng nhập thất bại: $e");
    } finally {
      isLoading(false);
    }
  }
}
