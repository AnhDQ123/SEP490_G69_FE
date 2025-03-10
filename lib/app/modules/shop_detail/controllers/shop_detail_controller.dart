import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ShopDetailController extends GetxController {
  // Thông tin text
  final storeName = 'Cơm rang Minh Nhật'.obs;
  final operatingHours = '7:00 - 22:00'.obs;
  final description = 'Cơm ngon mỗi ngày!'.obs;
  final address = '70 Trần Hưng Đạo, Smart City, Hà Nội, Việt Nam'.obs;
  final phone = '******469'.obs;
  final email = 'n*****@gmail.com'.obs;

  // Đường dẫn ảnh bìa và logo (RxnString cho phép null)
  final coverImagePath = RxnString();
  final logoImagePath = RxnString();

  // Hàm chọn ảnh bìa
  Future<void> pickCoverImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      coverImagePath.value = pickedFile.path;
    }
  }

  // Hàm chọn logo
  Future<void> pickLogoImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      logoImagePath.value = pickedFile.path;
    }
  }

  // Hàm lưu thông tin (gửi API hoặc xử lý tuỳ ý)
  void saveStoreInfo() {
    // ...
    // Thực hiện lưu dữ liệu lên server, local, v.v.
  }
}
