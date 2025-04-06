import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../service/banner_service.dart';

class AddBannerController extends GetxController {
  final BannerService _bannerService = BannerService();
  final RxString imagePath = ''.obs;
  final RxBool isLoading = false.obs;
  final maxFileSize = 30 * 1024 * 1024; // 30MB in bytes

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Giảm chất lượng ảnh để tối ưu
      );

      if (pickedFile == null) return;

      // Kiểm tra kích thước file
      final file = File(pickedFile.path);
      if (await file.length() > maxFileSize) {
        throw "Kích thước ảnh vượt quá 30MB";
      }

      imagePath.value = pickedFile.path;
    } catch (e) {
      _showErrorSnackbar("Lỗi", e.toString());
    }
  }

  Future<void> uploadBanner() async {
    if (imagePath.isEmpty) {
      _showErrorSnackbar("Lỗi", "Vui lòng chọn hình ảnh");
      return;
    }

    isLoading.value = true;
    try {
      final isSuccess = await _bannerService.addBanner(File(imagePath.value));

      if (isSuccess) {
        Get.back(); // Đóng màn hình sau khi thành công
        _showSuccessSnackbar("Thành công", "Tải banner lên thành công");
      } else {
        _showErrorSnackbar("Lỗi", "Tải lên thất bại. Vui lòng thử lại");
      }
    } catch (e) {
      _showErrorSnackbar("Lỗi hệ thống", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
    );
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[400],
      colorText: Colors.white,
    );
  }
}