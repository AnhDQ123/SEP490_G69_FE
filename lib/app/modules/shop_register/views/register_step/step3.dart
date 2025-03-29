import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/shop_register_controller.dart';

class Step3 extends StatelessWidget {
  final ShopRegisterController controller = Get.find();

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thông tin cơ bản",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),

          buildLogoUploader(
            imageController: controller.logo,
            onGalleryPick: () =>
                controller.pickImageFromGallery(controller.logo),
            onCameraPick: () => controller.pickImageFromCamera(controller.logo),
            onRemove: () => controller.removeImage(controller.logo),
          ),

          SizedBox(height: 12),

          // Background image uploader
          buildBackgroundUploader(
            imageController: controller.backgroundImage,
            onGalleryPick: () =>
                controller.pickImageFromGallery(controller.backgroundImage),
            onCameraPick: () =>
                controller.pickImageFromCamera(controller.backgroundImage),
            onRemove: () => controller.removeImage(controller.backgroundImage),
          ),
          SizedBox(height: 12),
          // Tên cửa hàng
          buildTextField(controller.shopName,
              label: "Tên cửa hàng", isRequired: true),

          // Giờ mở cửa & Giờ đóng cửa
          Row(
            children: [
              Expanded(
                  child: _buildTimePicker("Giờ mở cửa", controller.openTime)),
              SizedBox(width: 12),
              Expanded(
                  child:
                      _buildTimePicker("Giờ đóng cửa", controller.closeTime)),
            ],
          ),

          // Địa chỉ
          buildTextField(controller.address,
              label: "Địa chỉ", isRequired: true),

          // Số điện thoại
          _buildPhoneNumberField(controller.phoneNumber,
              label: "Số điện thoại"),

          // Miêu tả (không bắt buộc)
          buildTextField(controller.description,
              label: "Miêu tả", isRequired: false),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String label, Rxn<TimeOfDay> timeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(
                text: " *",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: Get.context!,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              timeController.value = pickedTime;
            }
          },
          child: Obx(() => Container(
                width: double.infinity, // Giúp mở rộng toàn bộ chiều ngang
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  controller.formatTime(timeController.value).isEmpty
                      ? "Chọn giờ"
                      : controller.formatTime(timeController.value),
                  style: TextStyle(
                    fontSize: 16,
                    color: controller.formatTime(timeController.value).isEmpty
                        ? Colors.grey
                        : Colors.black87,
                  ),
                ),
              )),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget buildTextField(RxString controllerValue, {String label = "", bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: isRequired
                ? [
              TextSpan(
                text: " *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ]
                : [],
          ),
        ),
        SizedBox(height: 4),
        Obx(() => TextField(
          controller: TextEditingController(text: controllerValue.value),
          onChanged: (value) => controllerValue.value = value,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        )),
        SizedBox(height: 8),
      ],
    );
  }


  Widget _buildPhoneNumberField(RxString controllerValue, {String label = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: label,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
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
        SizedBox(height: 4),
        Obx(() => TextField(
          controller: TextEditingController(text: controllerValue.value), // Sử dụng TextEditingController để đảm bảo giá trị được hiển thị
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
            LengthLimitingTextInputFormatter(10), // Giới hạn độ dài 10 số
          ],
          onChanged: (value) => controllerValue.value = value,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        )),
        SizedBox(height: 8),
      ],
    );
  }


  Widget buildLogoUploader({
    required Rxn<File> imageController,
    required Function() onGalleryPick,
    required Function() onCameraPick,
    required Function() onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa nội dung
      children: [
        RichText(
          text: TextSpan(
            text: "Logo cửa hàng ",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Center(
          // Căn giữa toàn bộ khung logo
          child: Obx(() => GestureDetector(
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
                child: Stack(
                  alignment: Alignment.center, // Căn giữa icon xoá
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: imageController.value == null
                          ? Icon(Icons.add_a_photo,
                              size: 40, color: Colors.grey)
                          : ClipOval(
                              child: Image.file(
                                imageController.value!,
                                width: 120,
                                height: 120,
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
                ),
              )),
        ),
      ],
    );
  }

  Widget buildBackgroundUploader({
    required Rxn<File> imageController,
    required Function() onGalleryPick,
    required Function() onCameraPick,
    required Function() onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa nội dung
      children: [
        Text(
            "Ảnh bìa",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        SizedBox(height: 8),
        Center(
          // Căn giữa toàn bộ khung ảnh nền
          child: Obx(() => GestureDetector(
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
            child: Stack(
              alignment: Alignment.center, // Căn giữa icon xoá
              children: [
                Container(
                  width: double.infinity, // Mở rộng ảnh nền hết chiều ngang
                  height: 200, // Bạn có thể điều chỉnh chiều cao phù hợp với thiết kế
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageController.value == null
                      ? Icon(Icons.add_a_photo,
                      size: 40, color: Colors.grey)
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      imageController.value!,
                      width: double.infinity,
                      height: double.infinity,
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
            ),
          )),
        ),
      ],
    );
  }

}
