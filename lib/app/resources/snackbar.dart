import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showSuccess(String message) {
    Get.snackbar(
      "Thành công",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    );
  }

  static void showWarning(String message) {
    Get.snackbar(
      "Cảnh báo",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    );
  }

  static void showError(String message) {
    Get.snackbar(
      "Lỗi",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    );
  }
}
