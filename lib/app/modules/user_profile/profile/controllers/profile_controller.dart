import 'package:get/get.dart';
import '../../../../base/base_common.dart';
import '../../../../service/user_service.dart';
import '../../../../models/user_profile.dart';

class ProfileController extends GetxController {
  var userName = "".obs;
  var avatarUrl = "".obs;

  // Cập nhật trạng thái theo enum OrderStatus với tên tiếng Việt
  var orderStatus = [
    "Chờ xác nhận",    // PENDING
    "Đang chuẩn bị",   // PROCESSING
    "Chờ vận chuyển",  // SHIP_PENDING
    "Đang giao",       // SHIPPING
    "Đã giao",         // DELIVERED
    "Đã huỷ",          // CANCELLED
    "Đã trả hàng",     // RETURNED
    "Đơn hàng bị từ chối", // REJECTED
    "Chờ trả hàng",    // RETURN_PENDING
    "Trả hàng bị từ chối", // RETURN_REJECTED
  ].obs;

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
