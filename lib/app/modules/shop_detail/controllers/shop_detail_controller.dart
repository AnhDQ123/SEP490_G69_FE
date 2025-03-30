import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/shop_profile.dart';

class ShopDetailController extends GetxController {
  late ShopProfile shop;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();

  final Rx<File?> coverImage = Rx<File?>(null);
  final Rx<File?> logoImage = Rx<File?>(null);

  final Rx<TimeOfDay> openTime = Rx<TimeOfDay>(TimeOfDay(hour: 7, minute: 0));
  final Rx<TimeOfDay> closeTime = Rx<TimeOfDay>(TimeOfDay(hour: 22, minute: 0));

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

  Future<void> pickCoverImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      coverImage.value = File(picked.path);
    }
  }

  Future<void> pickLogoImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      logoImage.value = File(picked.path);
    }
  }

  void onSave() {
    print('✅ Lưu thông tin...');
    print('Tên: ${nameController.text}');
    print('Giờ mở: ${openTime.value.format(Get.context!)}');
    print('Giờ đóng: ${closeTime.value.format(Get.context!)}');
    print('Logo mới: ${logoImage.value?.path}');
    print('Ảnh bìa mới: ${coverImage.value?.path}');
    // TODO: gửi lên server
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
