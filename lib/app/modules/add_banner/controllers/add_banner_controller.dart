import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddBannerController extends GetxController {
  var imagePath = ''.obs;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
    }
  }

  void uploadBanner() {
    if (imagePath.value.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng chọn một hình ảnh!", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Gửi ảnh lên server (cần API để xử lý)
    Get.snackbar("Thành công", "Banner đã được tải lên!", snackPosition: SnackPosition.BOTTOM);
    Get.back(); // Quay lại màn hình trước
  }
}
