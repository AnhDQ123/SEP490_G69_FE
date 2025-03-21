import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_view.dart';
import '../../forgot_password/controllers/forgot_password_controller.dart';

class ResetPasswordView extends BaseView<ForgotPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đặt lại mật khẩu của bạn")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Vui lòng nhập mật khẩu mới."),
            const SizedBox(height: 10),

            TextField(
              controller: controller.newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Mật khẩu mới",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: controller.confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Nhập lại mật khẩu mới",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Quay lại"),
                ),
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.resetPassword,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Hoàn thành"),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
