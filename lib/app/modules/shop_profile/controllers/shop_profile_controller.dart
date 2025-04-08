import 'package:get/get.dart';

class ShopProfileController extends GetxController {
  // Các thuộc tính của cửa hàng
  RxBool isEditing = false.obs;
  RxString shopName = 'Com rang Minh Nhật'.obs;
  RxString shopHours = '7:00 - 22:00'.obs;
  RxString shopDescription = 'Cơm ngon mỗi ngày!'.obs;
  RxString shopAddress = '70 Trần Hưng Đạo, Smart City, Hà Nội, Việt Nam'.obs;
  RxString shopPhone = '******469'.obs;
  RxString shopEmail = 'n*****@gmail.com'.obs;

  // Toggle chế độ chỉnh sửa
  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  // Cập nhật thông tin cửa hàng
  void updateShopName(String value) => shopName.value = value;
  void updateShopHours(String value) => shopHours.value = value;
  void updateShopDescription(String value) => shopDescription.value = value;
  void updateShopAddress(String value) => shopAddress.value = value;
  void updateShopPhone(String value) => shopPhone.value = value;
  void updateShopEmail(String value) => shopEmail.value = value;

  // Lưu thông tin cửa hàng
  void saveShopProfile() {
    // Logic lưu dữ liệu (ví dụ: lưu vào cơ sở dữ liệu)
    isEditing.value = false;  // Thoát chế độ chỉnh sửa
  }

  // Hủy bỏ thay đổi
  void cancelEdit() {
    isEditing.value = false;
  }
}
