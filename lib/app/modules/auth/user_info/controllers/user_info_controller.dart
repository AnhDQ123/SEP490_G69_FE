
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ffb_fe_flutter/app/service/register_service.dart';
import 'package:intl/intl.dart';
import '../../../../resources/snackbar.dart';

class UserInfoController extends GetxController {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  // Loại bỏ genderController vì giờ dùng biến phản ứng cho Dropdown
  // final genderController = TextEditingController();

  // Sử dụng biến phản ứng để quản lý giá trị giới tính
  var selectedGender = 'Nam'.obs;
  final isLoading = false.obs;
  var dob = Rx<DateTime?>(null);
  File? avatarFile;
  final ImagePicker _picker = ImagePicker();

  // Nhận user_id từ Get.arguments (được chuyển từ bước đăng ký email/mật khẩu)
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['user_id'] != null) {
      userId.value = Get.arguments['user_id'].toString();
    }
    print("User ID nhận được: ${userId.value}");
  }

  // Hàm chọn ảnh avatar từ thư viện
  Future<void> pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      avatarFile = File(pickedFile.path);
      update();
    }
  }

  // Hàm chọn ngày sinh
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dob.value ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dob.value = picked;
      update();
    }
  }

  // Hàm gửi dữ liệu cập nhật profile
  Future<void> submitProfileUpdate() async {
    // Kiểm tra đầy đủ thông tin: tên, địa chỉ, giới tính (selectedGender), ngày sinh và avatar
    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        selectedGender.value.trim().isEmpty ||
        dob.value == null ||
        avatarFile == null) {
      CustomSnackbar.showError("Vui lòng điền đầy đủ thông tin và chọn ảnh avatar.");
      return;
    }
    isLoading(true);
    try {
      String dobStr = DateFormat('yyyy-MM-dd').format(dob.value!);
      Map<String, dynamic> response = await RegisterService().updateUserProfile(
          userId.value,
          nameController.text.trim(),
          // Sử dụng selectedGender thay cho genderController.text
          selectedGender.value,
          dobStr,
          addressController.text.trim(),
          avatarFile!
      );
      if (response['success']) {
        CustomSnackbar.showSuccess(response['message']);
        // Chuyển hướng hoặc cập nhật UI sau khi thành công
        Get.offAllNamed('/login');
      } else {
        CustomSnackbar.showError(response['message']);
      }
    } catch (e) {
      CustomSnackbar.showError("Có lỗi xảy ra: $e");
    } finally {
      isLoading(false);
    }
  }
}

