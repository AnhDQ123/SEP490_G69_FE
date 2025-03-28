import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_view.dart';
import '../../../../resources/widget/header_widget.dart';
import '../../../../resources/widget/tab_switch_auth_widget.dart';
import '../controllers/register_controller.dart';

class RegisterView extends BaseView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(backgroundColor: Color.fromRGBO(249, 244, 241, 1)),
          TabSwitchWidget(isLogin: false),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  TextField(
                    controller: controller.phoneController,
                    // Sử dụng onChanged để kiểm tra và cập nhật lại giá trị của TextField
                    onChanged: (value) {
                      // Nếu người dùng nhập 9 chữ số (không có số 0 ở đầu) thì tự động thêm số 0 vào đầu
                      if (value.length == 9 && !value.startsWith("0")) {
                        String newValue = "0" + value;
                        controller.phoneController.value = TextEditingValue(
                          text: newValue,
                          selection: TextSelection.collapsed(offset: newValue.length),
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Nhập số điện thoại",
                      prefixText: "+84 ",
                      helperText:
                      "Nhập số điện thoại sau mã quốc gia +84 hoặc chuyển đổi sang 0 nếu cần",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    keyboardType: TextInputType.phone,
                  ),

                  SizedBox(height: 10),

                  Obx(() => controller.errorMessage.isNotEmpty
                      ? Text(controller.errorMessage.value,
                      style: TextStyle(color: Colors.red, fontSize: 14))
                      : SizedBox.shrink()),

                  SizedBox(height: 20),
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(212, 163, 115, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white) // Hiển thị loading
                        : Text("Tiếp theo"),
                  )),

                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  // Điều khoản
                  Text(
                    "Bằng cách đăng ký, bạn đồng ý với Điều khoản Dịch vụ & Chính sách Bảo mật của FastF&B.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11),
                  ),

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
