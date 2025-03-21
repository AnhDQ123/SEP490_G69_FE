import 'package:get/get.dart';
import '../../../../service/user_service.dart';

class ProfileController extends GetxController {
  var userName = "".obs;
  var orderStatus = ["Chờ xác nhận", "Đang chuẩn bị", "Đang giao", "Đã giao", "Đã huỷ", "Hoàn tiền"].obs;
  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() async {
    try {
      final data = await _userService.fetchUserProfile(46);
      print("Data received: $data");
      if (data != null) {
        userName.value = data['name'] ?? "";
        print("User name updated to: ${userName.value}");
      } else {
        print("Failed to fetch profile - data is null");
      }
    } catch (e, stackTrace) {
      print("Error during fetchProfile: $e");
      print("Stack trace: $stackTrace");
    }
  }


}

