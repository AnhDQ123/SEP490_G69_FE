import 'dart:developer';

import 'package:get/get.dart';
import '../../../../base/base_common.dart';
import '../../../../routes/app_pages.dart';
import '../../../../service/user_service.dart';
import '../../../../models/user_profile.dart';

class ProfileController extends GetxController {
  var userName = "".obs;
  var avatarUrl = "".obs;
  var isShopOwner = false.obs; // Trạng thái người dùng có cửa hàng hay không
  var shopId = RxInt(-1); // Biến lưu trữ shopId, mặc định là -1 (chưa có)

  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    fetchProfile(); // Lấy thông tin người dùng
    fetchUserShop(); // Kiểm tra cửa hàng của người dùng khi vào trang Profile
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

  void fetchUserShop() async {
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

      // Gọi API để lấy thông tin cửa hàng
      var shopInfo = await _userService.fetchUserShop(userId);

      if (shopInfo is String) {
        // Xử lý các thông báo lỗi từ API
        print("Thông báo lỗi từ API: $shopInfo");
        if (shopInfo.contains("Shop not found")) {
          // Nếu cửa hàng không tìm thấy, set trạng thái isShopOwner là false
          isShopOwner.value = false;
        }
      } else if (shopInfo is Map<String, dynamic>) {
        String status = shopInfo['isActive'] ?? 'Chưa có trạng thái';
        // Nếu cửa hàng đang hoạt động, set trạng thái isShopOwner là true
        if (status == 'ACTIVE') {
          isShopOwner.value = true;
          shopId.value = shopInfo['id'] ?? -1; // Lưu shopId nếu cửa hàng đang hoạt động
        } else {
          isShopOwner.value = false;
        }
      }
    } catch (e, stackTrace) {
      print("❌ Lỗi khi fetchUserShop: $e");
      print(stackTrace);
    }
  }
}




