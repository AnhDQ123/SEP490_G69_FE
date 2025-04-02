import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../resources/text_style.dart';
import '../../controllers/shop_register_controller.dart';

class Step4 extends StatelessWidget {
  final ShopRegisterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vui lòng chuẩn bị các giấy tờ liên quan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Vui lòng xem và điền các giấy tờ liên quan để xác thực cho việc đăng ký cửa hàng",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            buildTextField(controller.idCard,
                label: "Số CCCD/CMND/Hộ chiếu",
                isRequired: true,
                maxLength: 12),
            buildImageUploader(
                label: "Mặt trước CCCD/CMND",
                imageController: controller.idCardFrontImage,
                onGalleryPick: () => controller
                    .pickImageFromGallery(controller.idCardFrontImage),
                onCameraPick: () =>
                    controller.pickImageFromCamera(controller.idCardFrontImage),
                onRemove: () =>
                    controller.removeImage(controller.idCardFrontImage),
                isCCCD: true,
                isRequired: true),
            const SizedBox(height: 12),
            buildImageUploader(
                label: "Mặt sau CCCD/CMND",
                imageController: controller.idCardBackImage,
                onGalleryPick: () =>
                    controller.pickImageFromGallery(controller.idCardBackImage),
                onCameraPick: () =>
                    controller.pickImageFromCamera(controller.idCardBackImage),
                onRemove: () =>
                    controller.removeImage(controller.idCardBackImage),
                isCCCD: true,
                isRequired: true),
            const SizedBox(height: 12),
            _buildDatePicker("Ngày hết hạn", controller.issuedDate),
            const SizedBox(height: 12),
            buildTextField(controller.taxCode,
                label: "Mã số thuế", isRequired: true),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: buildImageUploader(
                      label: "Giấy phép đăng ký kinh doanh    ",
                      imageController: controller.registrationCertificateImage,
                      onGalleryPick: () => controller.pickImageFromGallery(
                          controller.registrationCertificateImage),
                      onCameraPick: () => controller.pickImageFromCamera(
                          controller.registrationCertificateImage),
                      onRemove: () => controller
                          .removeImage(controller.registrationCertificateImage),
                      isLicense: true,
                      isRequired: true),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: buildImageUploader(
                      label: "Giấy phép an toàn thực phẩm",
                      imageController: controller.safetyPolicyImage,
                      onGalleryPick: () => controller
                          .pickImageFromGallery(controller.safetyPolicyImage),
                      onCameraPick: () => controller
                          .pickImageFromCamera(controller.safetyPolicyImage),
                      onRemove: () =>
                          controller.removeImage(controller.safetyPolicyImage),
                      isLicense: true,
                      isRequired: true),
                ),
              ],
            ),
            const SizedBox(height: 12),
            buildImageUploader(
              label: "Ảnh sản phẩm",
              imageController: controller.productImage,
              onGalleryPick: () =>
                  controller.pickImageFromGallery(controller.productImage),
              onCameraPick: () =>
                  controller.pickImageFromCamera(controller.productImage),
              onRemove: () => controller.removeImage(controller.productImage),
            ),
            const SizedBox(
              height: 12,
            ),
            RichText(
              text: TextSpan(
                  text: "Chọn ngân hàng",
                  style: GoogleFonts.montserrat( // Áp dụng GoogleFonts cho text
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(
                      text: " *",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ]),
            ),
            const SizedBox(height: 4),
            Obx(() => controller.isLoadingBanks.value
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField(
                    value: controller.selectedBank.value,
                    isExpanded: true,
                    items: controller.bankList.map((bank) {
                      return DropdownMenuItem(
                        value: bank,
                        child: Text(bank.shortName,
                            overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedBank.value = value;
                      controller.selectedBankBin.value = value?.bin ?? '';
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Chọn ngân hàng",
                    ),
                  )),
            const SizedBox(height: 12),
            buildTextField(controller.bankInfo,
                label: "Số tài khoản ngân hàng", isRequired: true),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(RxString controllerValue,
      {String label = "", bool isRequired = false, int maxLength = 100}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.montserrat( // Áp dụng GoogleFonts cho text
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            children: isRequired
                ? [
                    TextSpan(
                      text: " *",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(height: 4),
        TextField(
          keyboardType: TextInputType.number,
          // Đảm bảo bàn phím chỉ hiển thị số
          onChanged: (value) => controllerValue.value = value,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            // Chỉ cho phép nhập số
            LengthLimitingTextInputFormatter(maxLength),
            // Giới hạn độ dài tối đa
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget buildImageUploader({
    required String label,
    required Rxn<File> imageController,
    required Function() onGalleryPick,
    required Function() onCameraPick,
    required Function() onRemove,
    bool isCCCD = false,
    bool isLicense = false,
    bool isRequired = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double width =
            isCCCD ? screenWidth : (isLicense ? screenWidth * 0.45 : 120);
        double height = isCCCD ? width * 0.6 : (isLicense ? width * 1.5 : 120);
        double borderRadius = 12;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: GoogleFonts.montserrat( // Áp dụng GoogleFonts cho text
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text("Chụp ảnh"),
                          onTap: () {
                            onCameraPick();
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text("Chọn từ thư viện"),
                          onTap: () {
                            onGalleryPick();
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Obx(() => Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: imageController.value == null
                            ? Icon(Icons.add_a_photo,
                                size: 40, color: Colors.grey)
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                                child: Image.file(
                                  imageController.value!,
                                  width: width,
                                  height: height,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      if (imageController.value != null)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: onRemove,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePicker(String label, Rxn<DateTime> dateController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: GoogleFonts.montserrat( // Áp dụng GoogleFonts cho text
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: dateController.value ?? DateTime.now(),
              firstDate: DateTime.now(), // Chỉ cho phép chọn ngày từ hiện tại trở đi
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              if (pickedDate.isBefore(DateTime.now())) {
                // Hiển thị thông báo nếu người dùng chọn ngày quá khứ
                Get.snackbar("Thông báo", "Vui lòng chọn ngày từ hôm nay trở đi.");
              } else {
                dateController.value = pickedDate;
              }
            }
          },
          child: Obx(() => Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              dateController.value != null
                  ? "${dateController.value!.day}/${dateController.value!.month}/${dateController.value!.year}"
                  : "Chọn ngày",
              style: TextStyle(
                fontSize: 16,
                color: dateController.value != null
                    ? Colors.black87
                    : Colors.grey,
              ),
            ),
          )),
        ),
        SizedBox(height: 8),
      ],
    );
  }

}
