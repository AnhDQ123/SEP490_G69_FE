import 'dart:io';
import '../../../models/bank.dart';
import '../../../resources/text_style.dart';
import 'register_step/step1.dart';
import 'register_step/step2.dart';
import 'register_step/step3.dart';
import 'register_step/step4.dart';
import 'step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_register_controller.dart';

class ShopRegisterView extends GetView<ShopRegisterController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentStep.value > 0) {
          controller.previousStep(); // Quay lại step trước
          controller.update(); // Cập nhật lại giao diện khi quay lại
          return false; // Chặn thoát ứng dụng
        }
        return true; // Thoát ứng dụng nếu đang ở Step 0
      },
      child: Scaffold(
        appBar: AppBar(
            title: TextConstant.titleH2(
                context,
                text: "Đăng ký cửa hàng",
            ),
        ),
        body: Column(
          children: [
            StepIndicator(),

            Expanded(
              child: Obx(() {
                final step = controller.currentStep.value; // đảm bảo Obx phụ thuộc vào biến Rx
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: _buildStepContent(),
                      ),
                    );
                  },
                );
              }),
            ),

            // Nút "Quay lại" & "Tiếp tục"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Obx(() => Visibility(
                    visible: controller.currentStep.value > 0,
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.previousStep();
                          controller.update(); // Cập nhật lại giá trị khi quay lại bước trước
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        child: TextConstant.subTile1(
                          context,
                          text: "Quay lại",
                        ),
                      ),
                    ),
                  )),
                  SizedBox(width: 12),
                  Obx(() => Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        switch (controller.currentStep.value) {
                          case 0:
                            if (controller.selectedService.value == null) {
                              Get.snackbar("Thông báo",
                                  "Vui lòng chọn đủ thông tin trước khi tiếp tục.");
                              return;
                            }
                            break;

                          case 1:
                            if (!controller.isTermsAccepted.value) {
                              Get.snackbar("Thông báo",
                                  "Bạn cần đồng ý với điều khoản trước khi tiếp tục.");
                              return;
                            }
                            break;

                          case 2:
                            if (controller.shopName.value.isEmpty ||
                                controller.openTime.value == null ||
                                controller.closeTime.value == null ||
                                controller.address.value.isEmpty ||
                                controller.phoneNumber.value.isEmpty) {
                              Get.snackbar("Thông báo",
                                  "Vui lòng điền đầy đủ thông tin cửa hàng trước khi tiếp tục.");
                              return;
                            }
                            break;

                          case 3:
                            if (controller.idCardFrontImage.value == null ||
                                controller.idCardBackImage.value == null ||
                                controller.issuedDate.value == null ||
                                controller.registrationCertificateImage.value == null ||
                                controller.safetyPolicyImage.value != null &&
                                    controller.taxCode.value.isEmpty) {
                              Get.snackbar("Thông báo",
                                  "Vui lòng tải lên đầy đủ giấy tờ theo yêu cầu.");
                              return;
                            }
                            break;

                          default:
                            break;
                        }
                        controller.nextStep();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(),
                        minimumSize: Size(double.infinity, 50), // Đảm bảo nút rộng ngang
                      ),
                      child: controller.currentStep.value == 3
                          ? Obx(() => controller.isSubmitting.value
                          ? CircularProgressIndicator(
                          color: Colors.white) // Hiển thị loading khi gửi API
                          : TextConstant.subTile1(
                        context,
                        text: "Đăng ký",
                      ))
                          : TextConstant.subTile1(
                        context,
                        text: "Tiếp tục",
                      ),
                    ),
                  ))
                ],
              ),
            ),
            // Tạo hiệu ứng mờ màn hình và vòng quay giữa màn hình
            Obx(() => Visibility(
              visible: controller.isSubmitting.value, // Kiểm tra nếu đang gửi dữ liệu
              child: Container(
                color: Colors.black.withOpacity(0.5), // Mờ màn hình
                child: Center(
                  child: CircularProgressIndicator(), // Vòng quay giữa màn hình
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor() {
    switch (controller.currentStep.value) {
      case 0:
        return (controller.selectedService.value != null)
            ? Color.fromRGBO(251, 196, 139, 1.0)
            : Color.fromRGBO(251, 196, 139, 0.50);
      case 1:
        return controller.isTermsAccepted.value
            ? Color.fromRGBO(251, 196, 139, 1.0)
            : Color.fromRGBO(251, 196, 139, 0.50);
      case 2:
        return (controller.shopName.value.isNotEmpty &&
            controller.openTime.value != null &&
            controller.closeTime.value != null &&
            controller.address.value.isNotEmpty &&
            controller.phoneNumber.value.isNotEmpty &&
            controller.logo.value != null)
            ? Color.fromRGBO(251, 196, 139, 1.0)
            : Color.fromRGBO(251, 196, 139, 0.50);
      case 3:
        return (controller.idCardFrontImage.value != null &&
            controller.idCardBackImage.value != null &&
            controller.issuedDate.value != null &&
            controller.registrationCertificateImage.value != null &&
            controller.safetyPolicyImage.value != null &&
            controller.taxCode.value.isNotEmpty &&
            controller.selectedBank.value != null &&
            controller.bankInfo.value.isNotEmpty)
            ? Color.fromRGBO(251, 196, 139, 1.0)
            : Color.fromRGBO(251, 196, 139, 0.50);
      default:
        return Colors.black;
    }
  }

  Widget _buildStepContent() {
    switch (controller.currentStep.value) {
      case 0:
        return Step1();
      case 1:
        return Step2();
      case 2:
        return Step3();
      case 3:
        return Step4();
      default:
        return Container();
    }
  }
}
