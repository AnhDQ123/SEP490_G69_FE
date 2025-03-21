import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../service/shipper_service.dart';

class ShipperRegisterController extends GetxController {
  // Các trường dữ liệu
  var fullName = ''.obs;
  var gender = ''.obs;
  var dateOfBirth = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var idNumber = ''.obs;
  var expiryDate = ''.obs;
  var licenseNumber = ''.obs;
  var licenseExpiry = ''.obs;

  // Ảnh giấy tờ
  var idFrontImage = Rxn<File>();
  var idBackImage = Rxn<File>();
  var licenseFrontImage = Rxn<File>();
  var licenseBackImage = Rxn<File>();
  var legalRecordImage = Rxn<File>();


  // Trạng thái hợp lệ của form
  final isFormValid = false.obs;

  final ImagePicker _picker = ImagePicker();

  // Gọi để chọn ảnh từ thư viện
  Future<void> pickImageFromGallery(Rxn<File> imageController) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageController.value = File(pickedFile.path);
      validateForm();
    }
  }

  Future<void> pickImageFromCamera(Rxn<File> imageController) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageController.value = File(pickedFile.path);
      validateForm();
    }
  }

  void removeImage(Rxn<File> imageController) {
    imageController.value = null;
    validateForm();
  }


  // Hàm kiểm tra xem form đã đầy đủ chưa
  void validateForm() {
    isFormValid.value = fullName.value.isNotEmpty &&
        gender.value.isNotEmpty &&
        dateOfBirth.value.isNotEmpty &&
        phone.value.isNotEmpty &&
        email.value.isNotEmpty &&
        GetUtils.isEmail(email.value) &&
        idNumber.value.isNotEmpty &&
        expiryDate.value.isNotEmpty &&
        idFrontImage.value != null &&
        idBackImage.value != null &&
        licenseNumber.value.isNotEmpty &&
        licenseExpiry.value.isNotEmpty &&
        licenseFrontImage.value != null &&
        licenseBackImage.value != null &&
        legalRecordImage.value != null;
  }

  // Hàm submit đăng ký
  void submitRegistration() async {
    if (!isFormValid.value) {
      Get.snackbar("Lỗi", "Vui lòng điền đầy đủ thông tin");
      return;
    }

    final response = await ShipperService().registerShipper(
      fullName: fullName.value,
      gender: gender.value,
      dateOfBirth: dateOfBirth.value,
      phone: phone.value,
      email: email.value,
      idNumber: idNumber.value,
      idExpiryDate: expiryDate.value,
      licenseNumber: licenseNumber.value,
      licenseExpiry: licenseExpiry.value,
      idFrontImage: idFrontImage.value,
      idBackImage: idBackImage.value,
      licenseFrontImage: licenseFrontImage.value,
      licenseBackImage: licenseBackImage.value,
      legalRecordImage: legalRecordImage.value,
    );

    if (response.success) {
      Get.snackbar("Thành công", response.message);
    } else {
      Get.snackbar("Thất bại", response.message);
    }
  }

}
