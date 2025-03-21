import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../resources/widget/header_widget.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(backgroundColor: Color.fromRGBO(249, 244, 241, 1)),
            SizedBox(height: 20),
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Nhập mã OTP đã gửi đến số ${controller.phoneNumber.value}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _otpBox(index)),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.verifyOtp,
                    style: _buttonStyle(),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Xác nhận"),
                  )),
                  SizedBox(height: 10),
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.resendOtp,
                    style: _buttonStyle(),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Gửi lại OTP"),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.textControllers[index].text.isEmpty) {
            if (index > 0) {
              FocusScope.of(Get.context!).requestFocus(controller.focusNodes[index - 1]);
            }
          }
        },
        child: TextField(
          controller: controller.textControllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              controller.otp[index].value = value;
              if (index < 5) {
                FocusScope.of(Get.context!).requestFocus(controller.focusNodes[index + 1]);
              } else {
                controller.focusNodes[index].unfocus();
              }
            }
          },
        ),
      ),
    );
  }


  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Color.fromRGBO(212, 163, 115, 1),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      minimumSize: Size(double.infinity, 50),
    );
  }
}