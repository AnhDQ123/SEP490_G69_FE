import 'dart:io';
import 'package:get/get.dart';

import '../../../../service/user_service.dart';

class EditProfileController extends GetxController {
  final UserService userService = UserService();

  var userProfile = {}.obs;
  var isLoading = false.obs;
  var selectedAvatar = Rx<File?>(null);

  Future<void> fetchUserProfile(int userId) async {
    isLoading.value = true;
    final data = await userService.fetchUserProfile(userId);
    if (data != null) {
      userProfile.assignAll(data);
    }
    isLoading.value = false;
  }

  Future<void> updateUserProfile(Map<String, String> userData, File avatar) async {
    isLoading.value = true;
    final data = await userService.updateUserProfile(userData, avatar);
    if (data != null) {
      userProfile.assignAll(data);
      Get.snackbar("Thành công", "Cập nhật profile thành công");
    } else {
      Get.snackbar("Lỗi", "Cập nhật profile thất bại");
    }
    isLoading.value = false;
  }
}
