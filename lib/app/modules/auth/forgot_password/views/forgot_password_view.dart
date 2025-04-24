import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_view.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends BaseView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tìm tài khoản của bạn")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vui lòng nhập số điện thoại để tìm kiếm tài khoản.",
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.phoneEmailController,
              decoration: const InputDecoration(
                hintText: "Số điện thoại",
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
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.sendResetRequest,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Tiếp tục"),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
