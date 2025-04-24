import 'package:ffb_fe_flutter/app/resources/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_common.dart';
import '../../../../base/base_controller.dart';
import '../../../../routes/app_pages.dart';
import '../../../../service/login_service.dart';
import '../../../../service/notification_service.dart';
import '../../../cart/controllers/cart_controller.dart';

class LoginController extends BaseController {
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final errorMessage = ''.obs;
  final LoginService _loginService = LoginService();
  final isPasswordHidden = true.obs;


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
        await BaseCommon.instance.saveToken(token);

        // ✅ Gọi CartController và fetchCart để kiểm tra giỏ hàng
        final cartController = Get.put(CartController());
        await cartController.fetchCart();

        // ✅ Đếm số sản phẩm
        int totalItems = 0;
        for (var shop in cartController.carts) {
          totalItems += shop.cartItemDTOList.length;
        }

        if (totalItems > 0) {
          await NotificationService.showCartReminderNotification(totalItems);
        }

        // ➡️ Điều hướng sau cùng
        Get.toNamed(Routes.HOME);
      }
      else {
        CustomSnackbar.showError("Token không hợp lệ hoặc rỗng.");
      }
    } catch (e) {
      CustomSnackbar.showError("Đăng nhập thất bại: $e");
    } finally {
      isLoading(false);
    }
  }
}
