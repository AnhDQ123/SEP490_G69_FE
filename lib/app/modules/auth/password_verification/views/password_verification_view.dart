import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resources/validate.dart';
import '../../../../resources/widget/header_widget.dart';
import '../controllers/password_verification_controller.dart';

class PasswordVerificationView extends GetView<PasswordVerificationController> {
  const PasswordVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(backgroundColor: Color.fromRGBO(212, 163, 115, 1)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(() => Text(
                    "Số điện thoại: ${controller.phoneNumber.value}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )),
                  SizedBox(height: 20),

                  // Trường Email với live validation
                  Obx(() => TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      // Kiểm tra định dạng email khi nhập và cập nhật lỗi ngay
                      String? error = Validate.validateEmail(value.trim());
                      controller.emailError.value = error ?? '';
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                      errorText: controller.emailError.value.isNotEmpty
                          ? controller.emailError.value
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  )),
                  // Hướng dẫn định dạng email
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: Text(
                      "Email phải có định dạng: example@domain.com",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Trường mật khẩu với live validation và toggle ẩn/hiện
                  Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordObscured.value,
                    onChanged: (value) {
                      String? error = Validate.validatePassword(value.trim());
                      controller.passwordError.value = error ?? '';
                      // Cập nhật lỗi cho xác nhận mật khẩu nếu cần
                      String? confirmError = Validate.validatePassword(
                        controller.confirmPasswordController.text.trim(),
                        confirmPassword: value.trim(),
                      );
                      controller.confirmPasswordError.value = confirmError ?? '';
                    },
                    decoration: InputDecoration(
                      labelText: "Mật khẩu mới",
                      errorText: controller.passwordError.value.isNotEmpty
                          ? controller.passwordError.value
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(controller.isPasswordObscured.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          controller.isPasswordObscured.value =
                          !controller.isPasswordObscured.value;
                        },
                      ),
                    ),
                  )),
                  // Hướng dẫn định dạng mật khẩu
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: Text(
                      "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@%^&*).",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Trường xác nhận mật khẩu với live validation và toggle ẩn/hiện
                  Obx(() => TextField(
                    controller: controller.confirmPasswordController,
                    obscureText: controller.isConfirmPasswordObscured.value,
                    onChanged: (value) {
                      String? error = Validate.validatePassword(
                        value.trim(),
                        confirmPassword: controller.passwordController.text.trim(),
                      );
                      controller.confirmPasswordError.value = error ?? '';
                    },
                    decoration: InputDecoration(
                      labelText: "Xác nhận mật khẩu",
                      errorText: controller.confirmPasswordError.value.isNotEmpty
                          ? controller.confirmPasswordError.value
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(controller.isConfirmPasswordObscured.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          controller.isConfirmPasswordObscured.value =
                          !controller.isConfirmPasswordObscured.value;
                        },
                      ),
                    ),
                  )),
                  SizedBox(height: 20),

                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.submitUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(212, 163, 115, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Tiếp theo"),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
