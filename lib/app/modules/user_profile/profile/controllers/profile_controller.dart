import 'package:get/get.dart';
import '../../../../base/base_common.dart';
import '../../../../service/user_service.dart';
import '../../../../models/user_profile.dart';

class ProfileController extends GetxController {
  var userName = "".obs;
  var avatarUrl = "".obs;
  var orderStatus = ["Chờ xác nhận", "Đang chuẩn bị", "Đang giao", "Đã giao", "Đã huỷ", "Hoàn tiền"].obs;
  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() async {
    try {
      final userIdStr = BaseCommon.instance.userId;
      if (userIdStr == null) {
        print("⚠️ Không tìm thấy userId trong BaseCommon");
        return;
      }

      final userId = int.tryParse(userIdStr);
      if (userId == null) {
        print("⚠️ userId không hợp lệ: $userIdStr");
        return;
      }

      UserProfile? profile = await _userService.fetchUserProfile(userId);
      print("Data received: $profile");

      if (profile != null) {
        userName.value = profile.name;
        avatarUrl.value = profile.avatar;
      } else {
        print("⚠️ fetchProfile trả về null");
      }
    } catch (e, stackTrace) {
      print("❌ Lỗi khi fetchProfile: $e");
      print(stackTrace);
    }
  }
}
