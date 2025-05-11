import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/base/base_common.dart';
import '../../../../models/bank.dart';
import '../../../../service/shop_service.dart';
import '../../../../service/user_service.dart';
import '../../../../models/user_profile.dart';

class EditProfileController extends GetxController {
  final UserService userService = UserService();

  var isLoading = false.obs;
  var selectedAvatar = Rx<File?>(null);

  // Các TextEditingController cho từng trường
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final accountController = TextEditingController();
  final bankCodeController = TextEditingController();
  final avatarUrl = "".obs;

  final ShopService shopService = ShopService();

  var bankList = <Bank>[].obs;
  var selectedBankCode = ''.obs; // Ngân hàng được chọn

  @override
  void onInit() {
    super.onInit();

    final userIdStr = BaseCommon.instance.userId;
    if (userIdStr != null) {
      final userId = int.tryParse(userIdStr);
      if (userId != null) {
        fetchUserProfile(userId).then((_) {
          fetchBankList();

        });
      } else {
        print("⚠️ userId không hợp lệ: $userIdStr");
      }
    } else {
      print("⚠️ userId chưa được lưu trong BaseCommon");
    }

  }

  Future<void> fetchBankList() async {
    final banks = await shopService.fetchBanks();
    bankList.assignAll(banks);

    // Đảm bảo chỉ set nếu bankCodeController có giá trị
    if (bankCodeController.text.isNotEmpty) {
      selectedBankCode.value = bankCodeController.text;

      // Debug thêm:
      print("🎯 BankCode từ backend: ${bankCodeController.text}");
      final matchedBank = banks.firstWhereOrNull((b) => b.bin == bankCodeController.text);
      print("✅ Tìm thấy ngân hàng: ${matchedBank?.shortName}");
    }
  }


  Future<void> fetchUserProfile(int userId) async {
    isLoading.value = true;
    final data = await userService.fetchUserProfile(userId);
    if (data != null) {
      nameController.text = data.name ?? "";
      genderController.text = data.gender ?? "";
      dobController.text = data.dob ?? "";
      phoneController.text = data.phone ?? "";
      emailController.text = data.email ?? "";
      addressController.text = data.address ?? "";
      avatarUrl.value = data.avatar ?? "";
      accountController.text = data.accountNumber ?? '';
      bankCodeController.text = data.bankCode ?? '';
      selectedBankCode.value = data.bankCode ?? '';
      print('✅ accountNumber: ${data.accountNumber}');
      print('✅ bankCode (bin): ${data.bankCode}');


    }
    isLoading.value = false;
  }

  Future<void> updateUserProfile() async {
    isLoading.value = true;

    Map<String, String> userData = {
      "name": nameController.text,
      "gender": genderController.text,
      "dob": dobController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "address": addressController.text,
      "accountNumber": accountController.text,
      "bankCode": bankCodeController.text,
    };

    final avatar = selectedAvatar.value;

    if (avatar == null) {
      Get.snackbar("Lỗi", "Vui lòng chọn ảnh đại diện");
      isLoading.value = false;
      return;
    }

    final data = await userService.updateUserProfile(userData, avatar);

    if (data != null) {
      Get.snackbar("Thành công", "Cập nhật profile thành công");
    } else {
      Get.snackbar("Lỗi", "Cập nhật profile thất bại");
    }

    isLoading.value = false;
  }
}

