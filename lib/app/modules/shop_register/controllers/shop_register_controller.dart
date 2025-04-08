import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/bank.dart';
import '../../../routes/app_pages.dart';
import '../../../service/shop_service.dart';

class ShopRegisterController extends GetxController {

  var bankList = <Bank>[].obs;
  var selectedBank = Rxn<Bank>();
  var selectedBankBin = ''.obs;
  var isLoadingBanks = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Lấy `userId` từ `arguments` khi trang này được mở
    var arguments = Get.arguments;
    if (arguments != null && arguments['userId'] != null) {
      userId.value = arguments['userId'].toString();
      print("userId received: ${userId.value}");
    } else {
      print("userId not provided in arguments.");
    }

    fetchBanks();
  }

  void fetchBanks() async {
    isLoadingBanks.value = true;
    bankList.value = await ShopService().fetchBanks();
    isLoadingBanks.value = false;
  }

  var currentStep = 0.obs;

  // Step 1
  var selectedService = RxnString();

  // Step 2
  var isTermsAccepted = false.obs;

  // Step 3 - Thông tin cửa hàng
  var logo = Rxn<File>();
  var backgroundImage = Rxn<File>();
  var shopName = ''.obs;
  var address = ''.obs;
  var phoneNumber = ''.obs;
  var description = ''.obs;
  var openTime = Rxn<TimeOfDay>();
  var closeTime = Rxn<TimeOfDay>();

  String formatTime(TimeOfDay? time) {
    if (time == null) return "";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  //Step 4
  var idCard = ''.obs;

  var idCardFrontImage = Rxn<File>();
  var idCardBackImage = Rxn<File>();
  var registrationCertificateImage = Rxn<File>();
  var safetyPolicyImage = Rxn<File>();
  var productImage = Rxn<File>();

  var issuedDate = Rxn<DateTime>();
  var taxCode = ''.obs;
  var bankInfo = ''.obs;

  var userId = ''.obs;

  final ImagePicker picker = ImagePicker();

  // Chọn ảnh đơn từ thư viện
  Future<void> pickImageFromGallery(Rxn<File> imageController) async {
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageController.value = File(pickedFile.path);
    }
  }

  // Chọn ảnh đơn từ camera
  Future<void> pickImageFromCamera(Rxn<File> imageController) async {
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageController.value = File(pickedFile.path);
    }
  }

  // Xóa ảnh đơn
  void removeImage(Rxn<File> imageController) {
    imageController.value = null;
  }

  bool get canProceed {
    switch (currentStep.value) {
      case 0:
        return selectedService.value != null;
      case 1:
        return isTermsAccepted.value;
      case 2:
        return shopName.value.isNotEmpty &&
            openTime.value != null &&
            closeTime.value != null &&
            address.value.isNotEmpty &&
            phoneNumber.value.isNotEmpty;
      case 3:
        return idCardFrontImage.value != null &&
            idCardBackImage.value != null &&
            issuedDate.value != null &&
            registrationCertificateImage.value != null &&
            taxCode.value.isNotEmpty &&
            safetyPolicyImage.value != null;
      default:
        return true;
    }
  }

  void nextStep() {
    if (canProceed && currentStep.value < 3) {
      currentStep.value++;
    } else if (currentStep.value == 3 && canProceed) {
      submitRegistration();
    } else {
      _showErrorMessage();
    }
  }

  var isSubmitting = false.obs; // Thêm biến này để kiểm soát trạng thái gửi API

  Future<void> submitRegistration() async {
    if (isSubmitting.value) return; // Tránh gọi API nhiều lần
    isSubmitting.value = true;

    try {
      var response = await ShopService().registerShop(
        userId: userId.value,  // Truyền `userId` động vào API
        //Step 1
        sellType: selectedService.value ?? "COOKED",
        //Step 2 không có input
        //Step 3
        backgroundImage: backgroundImage.value,
        logo: logo.value,
        name: shopName.value,
        openTime: formatTime(openTime.value),
        closeTime: formatTime(closeTime.value),
        address: address.value,
        description: description.value,

        //Step 4
        citizenIDNumber: idCard.value,
        citizenIDExpiredDate: issuedDate.value ?? DateTime(1900, 1, 1),
        citizenIDFront: idCardFrontImage.value,
        citizenIDBack: idCardBackImage.value,

        registrationCert: registrationCertificateImage.value,
        foodSafetyCert: safetyPolicyImage.value,
        menu: productImage.value,
        taxCode: taxCode.value,
        selectedBankBin: selectedBankBin.value,
        bankInfo: bankInfo.value,
      );

      print("Response từ API: ${response.success}, Message: ${response.message}");

      if (response.success) {
        Get.snackbar("Thành công", "Đăng ký cửa hàng thành công!");
        Future.delayed(Duration(seconds: 2), () {
          Get.offAllNamed(Routes.PROFILE); // ✅ Chuyển hướng về trang shop
        });
      } else {
        Get.snackbar("Lỗi", response.message);
      }
    } catch (e) {
      print("Lỗi khi gửi request: $e");
      Get.snackbar("Lỗi", "Có lỗi xảy ra khi gửi dữ liệu.");
    } finally {
      isSubmitting.value = false;
    }
  }


  void _showErrorMessage() {
    switch (currentStep.value) {
      case 0:
        Get.snackbar("Thông báo", "Vui lòng chọn loại hình dịch vụ và kinh doanh rượu/bia.");
        break;
      case 1:
        Get.snackbar("Thông báo", "Bạn cần đồng ý với điều khoản trước khi tiếp tục.");
        break;
      case 2:
        Get.snackbar("Thông báo", "Vui lòng điền đầy đủ thông tin cửa hàng trước khi tiếp tục.");
        break;
      case 3:
        Get.snackbar("Thông báo", "Vui lòng tải lên đầy đủ giấy tờ theo yêu cầu.");
        break;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

}


