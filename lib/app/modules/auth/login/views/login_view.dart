import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_view.dart';
import '../../../../resources/widget/header_widget.dart';
import '../../../../resources/widget/tab_switch_auth_widget.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends BaseView<LoginController> {
  const LoginView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(backgroundColor: Color.fromRGBO(249, 244, 241, 1)),
          TabSwitchWidget(isLogin: true),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),

                  TextField(
                    controller: controller.accountController,
                    decoration: InputDecoration(
                      hintText: "Số điện thoại",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Mật khẩu",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                  SizedBox(height: 10),

                  Obx(() => controller.errorMessage.isNotEmpty
                      ? Text(controller.errorMessage.value,
                      style: TextStyle(color: Colors.red, fontSize: 14))
                      : SizedBox.shrink()),

                  // Checkbox "Ghi nhớ đăng nhập"
                  // Obx(() => CheckboxListTile(
                  //   title: Text("Ghi  nhớ đăng nhập"),
                  //   value: controller.rememberMe.value,
                  //   onChanged: (value) {
                  //     controller.rememberMe.value = value ?? false;
                  //   },
                  //   controlAffinity: ListTileControlAffinity.leading,
                  // )),

                  SizedBox(height: 20),

                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(212, 163, 115, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Đăng nhập"),
                  )),

                  TextButton(
                    onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: Text("Quên mật khẩu?"),
                  ),

                  SizedBox(height: 10),

                  // Text(
                  //   "hoặc đăng nhập với",
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
