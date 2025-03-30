import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/shop_profile.dart';
import '../../../service/shop_service.dart';

class ShopDetailController extends GetxController {
  late ShopProfile shop;

  // Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();

  // Time
  final openTime = Rx<TimeOfDay>(TimeOfDay(hour: 0, minute: 0));
  final closeTime = Rx<TimeOfDay>(TimeOfDay(hour: 0, minute: 0));

  // File inputs
  final Rx<File?> logoImage = Rx<File?>(null);
  final Rx<File?> coverImage = Rx<File?>(null);

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    shop = Get.arguments as ShopProfile;

    nameController.text = shop.name;
    descriptionController.text = shop.description ?? '';
    addressController.text = shop.address;
    openTime.value = _parseTime(shop.openTime);
    closeTime.value = _parseTime(shop.closeTime);
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> pickLogoImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) logoImage.value = File(picked.path);
  }

  Future<void> pickCoverImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) coverImage.value = File(picked.path);
  }

  Future<void> onSave() async {
    try {
      isLoading.value = true;

      await ShopService().updateShop(
        shopId: shop.id,
        name: nameController.text,
        description: descriptionController.text,
        phone: shop.phone,
        address: addressController.text,
        openTime: openTime.value,
        closeTime: closeTime.value,
        taxCode: shop.owner.profile.taxCode,
        citizenIDNumber: shop.owner.profile.citizenIDNumber,
        citizenIDExpiredDate: shop.owner.profile.citizenIDExpiredDate,
        logoFile: logoImage.value,
        backgroundFile: coverImage.value,
      );

      // ✅ Quay về ngay
      Get.back(result: true);

      // ✅ Rồi hiển thị snackbar thành công
      Get.snackbar(
        'Thành công',
        'Thông tin cửa hàng đã được cập nhật.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        icon: Icon(Icons.check_circle, color: Colors.white),
      );

    } catch (e) {
      // ❌ Nếu lỗi
      Get.snackbar(
        'Lỗi',
        'Cập nhật thất bại. Vui lòng thử lại.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      print('❌ Cập nhật thất bại: $e');
    } finally {
      isLoading.value = false;
    }
  }



  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
