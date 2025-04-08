
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
  var phoneController = TextEditingController();

  // Nhận user_id từ Get.arguments (được chuyển từ bước đăng ký email/mật khẩu)
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final phone = Get.arguments?['phone'] ?? '';
    phoneController.text = phone; // Đúng cách gán giá trị cho TextEditingController
    print("Phone nhận được: $phone");
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

  Future<void> submitProfileUpdate() async {
    if (nameController.text.isEmpty || dob.value == null) {
      CustomSnackbar.showError("Vui lòng điền đầy đủ thông tin");
      return;
    }

    isLoading(true);
    try {
      String dobStr = DateFormat('yyyy-MM-dd').format(dob.value!);

      final response = await RegisterService().updateUserProfile(
        phoneController.text, // Đúng: lấy nội dung text từ controller
        nameController.text,
        selectedGender.value,
        dobStr,
        addressController.text,
        avatarFile,
      );

      if (response['success']) {
        CustomSnackbar.showSuccess(response['message']);
        Get.offAllNamed('/login');
      } else {
        CustomSnackbar.showError(response['message']);
      }
    } catch (e) {
      CustomSnackbar.showError("Lỗi: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}

