import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../routes/app_pages.dart';
import '../../../service/shipper_service.dart';

class ShipperRegisterController extends GetxController {
  RxBool isLoading = false.obs; // ✅ Trạng thái loading

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

  void submitRegistration(int userId) async {
    if (!isFormValid.value) {
      Get.snackbar("Lỗi", "Vui lòng điền đầy đủ thông tin");
      return;
    }

    isLoading.value = true; // ✅ Bắt đầu loading

    final response = await ShipperService().registerShipper(
      userId: userId,
      name: fullName.value,
      gender: gender.value,
      dob: formatDate(dateOfBirth.value),
      phone: phone.value,
      email: email.value,
      citizenIDNumber: idNumber.value,
      citizenIDExpiredDate: formatDate(expiryDate.value),
      drivingLicenseExpiredDate: formatDate(licenseExpiry.value),
      citizenIDFront: idFrontImage.value,
      citizenIDBack: idBackImage.value,
      drivingLicenseFront: licenseFrontImage.value,
      drivingLicenseBack: licenseBackImage.value,
      judicialRecord: legalRecordImage.value,
    );

    isLoading.value = false; // ✅ Kết thúc loading

    if (response.success) {
      Get.snackbar("Thành công", response.message);
      Future.delayed(Duration(seconds: 1), () {
        Get.offAllNamed(Routes.SHIPPER_HOME); // ✅ Chuyển trang khi thành công
      });
    } else {
      Get.snackbar("Thất bại", response.message);
    }
  }


  String formatDate(String date) {
    try {
      List<String> parts = date.split('/'); // Nếu date ở dạng "dd/MM/yyyy"
      if (parts.length == 3) {
        String day = parts[0].padLeft(2, '0');
        String month = parts[1].padLeft(2, '0');
        String year = parts[2];
        return "$year-$month-$day"; // Đổi thành yyyy-MM-dd
      }
      return date; // Trả về nguyên bản nếu không cần format
    } catch (e) {
      print("Lỗi khi xử lý ngày: $e");
      return "0000-00-00"; // Trả về giá trị mặc định nếu lỗi
    }
  }
}
