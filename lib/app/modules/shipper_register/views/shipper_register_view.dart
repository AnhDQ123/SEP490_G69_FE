import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/shipper_register_controller.dart';

class ShipperRegisterView extends StatelessWidget {
  final ShipperRegisterController controller = Get.put(ShipperRegisterController());
  final RxString emailError = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shipper Register")),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Điền thông tin để đăng kí làm người vận chuyển Fast F&B",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildTextField(controller.fullName, label: "Họ và tên", isRequired: true),
            _buildDropdownField(controller.gender, label: "Giới tính", items: ["Nam", "Nữ"]),
            _buildDatePicker(controller.dateOfBirth, label: "Ngày sinh"),
            _buildTextField(controller.phone, label: "Số điện thoại", isRequired: true, isNumeric: true),
            _buildEmailField(controller.email),
            _buildTextField(controller.idNumber, label: "Số CMND/Căn cước", isRequired: true, isNumeric: true),
            _buildDatePicker(controller.expiryDate, label: "Hạn CCCD", isFutureOnly: true),

            const SizedBox(height: 12),
            _buildImageUploader(
              label: "Ảnh mặt trước của CCCD",
              imageController: controller.idFrontImage,
              onGalleryPick: () => controller.pickImageFromGallery(controller.idFrontImage),
              onCameraPick: () => controller.pickImageFromCamera(controller.idFrontImage),
              onRemove: () => controller.removeImage(controller.idFrontImage),
            ),
            const SizedBox(height: 12),
            _buildImageUploader(
              label: "Ảnh mặt sau của CCCD",
              imageController: controller.idBackImage,
              onGalleryPick: () => controller.pickImageFromGallery(controller.idBackImage),
              onCameraPick: () => controller.pickImageFromCamera(controller.idBackImage),
              onRemove: () => controller.removeImage(controller.idBackImage),
            ),

            const SizedBox(height: 12),
            _buildTextField(controller.licenseNumber, label: "Giấy phép lái xe", isRequired: true, isNumeric: true),
            _buildDatePicker(controller.licenseExpiry, label: "Ngày hết hạn", isFutureOnly: true),
            _buildImageUploader(
              label: "Ảnh mặt trước của giấy phép lái xe",
              imageController: controller.licenseFrontImage,
              onGalleryPick: () => controller.pickImageFromGallery(controller.licenseFrontImage),
              onCameraPick: () => controller.pickImageFromCamera(controller.licenseFrontImage),
              onRemove: () => controller.removeImage(controller.licenseFrontImage),
            ),
            const SizedBox(height: 12),
            _buildImageUploader(
              label: "Ảnh mặt sau của giấy phép lái xe",
              imageController: controller.licenseBackImage,
              onGalleryPick: () => controller.pickImageFromGallery(controller.licenseBackImage),
              onCameraPick: () => controller.pickImageFromCamera(controller.licenseBackImage),
              onRemove: () => controller.removeImage(controller.licenseBackImage),
            ),
            const SizedBox(height: 12),
            _buildImageUploader(
              label: "Ảnh Lý Lịch Tư Pháp",
              imageController: controller.legalRecordImage,
              onGalleryPick: () => controller.pickImageFromGallery(controller.legalRecordImage),
              onCameraPick: () => controller.pickImageFromCamera(controller.legalRecordImage),
              onRemove: () => controller.removeImage(controller.legalRecordImage),
              isPortrait: true, // Ảnh Lý Lịch Tư Pháp theo chiều dọc
            ),

            const SizedBox(height: 20),
            Center(
              child: Obx(() => OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: controller.isFormValid.value
                      ? Color.fromRGBO(212, 163, 115, 1)
                      : Colors.grey[200],
                ),
                onPressed: controller.isFormValid.value && !controller.isLoading.value
                    ? () => controller.submitRegistration(1) // ✅ Tránh bấm nhiều lần khi đang gửi request
                    : null,

                child: controller.isLoading.value
                    ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.black, // ✅ Màu loading
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  "Đăng ký",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              )),
            ),

          ],
        ),
      ),
    );
  }


  Widget _buildTextField(RxString controllerValue,
      {String label = "", bool isRequired = false, bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: isRequired ? [TextSpan(text: " *", style: TextStyle(color: Colors.red))] : [],
          ),
        ),
        SizedBox(height: 4),
        TextField(
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
          onChanged: (value) {
            controllerValue.value = value;
            controller.validateForm();
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildEmailField(RxString controllerValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Email",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: [TextSpan(text: " *", style: TextStyle(color: Colors.red))],
          ),
        ),
        SizedBox(height: 4),
        TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            controllerValue.value = value;
            controller.validateForm();
          },
          onEditingComplete: () {
            if (controllerValue.value.isNotEmpty && !GetUtils.isEmail(controllerValue.value)) {
              emailError.value = "Email không hợp lệ";
            } else {
              emailError.value = "";
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        Obx(() => emailError.value.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            emailError.value,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        )
            : SizedBox()),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDropdownField(RxString controllerValue,
      {required String label, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: [TextSpan(text: " *", style: TextStyle(color: Colors.red))],
          ),
        ),
        SizedBox(height: 4),
        Obx(() => DropdownButtonFormField(
          value: controllerValue.value.isEmpty ? null : controllerValue.value,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: (value) {
            controllerValue.value = value as String;
            controller.validateForm();
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        )),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDatePicker(RxString controllerValue,
      {required String label, bool isFutureOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: [TextSpan(text: " *", style: TextStyle(color: Colors.red))],
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: isFutureOnly ? DateTime.now() : DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              controllerValue.value =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              controller.validateForm();
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
              controllerValue.value.isNotEmpty
                  ? controllerValue.value
                  : "Chọn ngày",
              style: TextStyle(
                fontSize: 16,
                color: controllerValue.value.isNotEmpty ? Colors.black87 : Colors.grey,
              ),
            ),
          )),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildImageUploader({
    required String label,
    required Rxn<File> imageController,
    required Function() onGalleryPick,
    required Function() onCameraPick,
    required Function() onRemove,
    bool isPortrait = false, // Thêm biến để xác định ảnh dọc (Lý Lịch Tư Pháp)
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double width = isPortrait ? screenWidth * 0.6 : screenWidth; // LLTP nhỏ hơn, CCCD/GPLX full width
        double height = isPortrait ? width * 1.5 : width * 0.6; // LLTP cao hơn (tỷ lệ 1.5:1)

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                label,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
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
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: imageController.value == null
                        ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
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
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, size: 16, color: Colors.white),
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




}
