import 'dart:developer';

import 'package:get/get.dart';
import '../../../../base/base_common.dart';
import '../../../../routes/app_pages.dart';
import '../../../../service/user_service.dart';
import '../../../../models/user_profile.dart';

enum Status {
  ACTIVE,
  INACTIVE,
  PENDING,
  REJECTED,
  DELETED;

  // Helper để convert từ String sang enum
  static Status fromString(String status) {
    return Status.values.firstWhere(
          (e) => e.name == status.toUpperCase(),
      orElse: () => Status.INACTIVE,
    );
  }
}

class ProfileController extends GetxController {
  var userName = "".obs;
  var avatarUrl = "".obs;
  var isShopOwner = false.obs; // Trạng thái người dùng có cửa hàng hay không
  var shopId = RxInt(-1); // Biến lưu trữ shopId, mặc định là -1 (chưa có)
  var isShipper = false.obs; // Thêm dòng này
  var shopStatus = Status.INACTIVE.obs; // Thêm dòng này
  var shipperStatus = Status.INACTIVE.obs; // Thêm trạng thái shipper
  var isLoadingShopInfo = true.obs; // Thêm dòng này




  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    isLoadingShopInfo.value = true;

    await Future.wait([
      fetchProfile(),
      fetchUserShop(),
      checkUserRoles(),
    ]);

    isLoadingShopInfo.value = false;
  }

  Future<void> fetchProfile() async {
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
        avatarUrl.value = profile.avatar!;
      } else {
        print("⚠️ fetchProfile trả về null");
      }
    } catch (e, stackTrace) {
      print("❌ Lỗi khi fetchProfile: $e");
      print(stackTrace);
    }
  }

  Future<void> fetchUserShop() async {
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
          shopStatus.value = Status.INACTIVE;
        }
      } else if (shopInfo is Map<String, dynamic>) {
        String status = shopInfo['isActive'] ?? 'Chưa có trạng thái';

        // Chỉ cập nhật nếu chưa được set từ roleProfile
        if (shopStatus.value == Status.INACTIVE) {
          shopStatus.value = Status.fromString(status);
        }
        // Cập nhật trạng thái cửa hàng
        if (status == 'ACTIVE') {
          isShopOwner.value = true;
          shopStatus.value = Status.ACTIVE;
          shopId.value = shopInfo['id'] ?? -1; // Lưu shopId nếu cửa hàng đang hoạt động
        } else if (status == 'PENDING') {
          shopStatus.value = Status.PENDING;
          isShopOwner.value = true; // Cửa hàng đang chờ duyệt
        } else {
          isShopOwner.value = false;
          shopStatus.value = Status.INACTIVE;
        }
      }
    } catch (e, stackTrace) {
      print("❌ Lỗi khi fetchUserShop: $e");
      print(stackTrace);
    }
  }


  Future<void> checkUserRoles() async {
    try {
      final userIdStr = BaseCommon.instance.userId;
      if (userIdStr == null) return;

      final userId = int.tryParse(userIdStr);
      if (userId == null) return;

      final roleProfile = await _userService.fetchUserRoleProfile(userId);

      if (roleProfile != null) {
        if (!isShopOwner.value) {
          isShopOwner.value = roleProfile.isShopOwner;
        }
        isShipper.value = roleProfile.isShipper;
        shopId.value = roleProfile.shopId ?? shopId.value; // Giữ giá trị cũ nếu null

        // Sửa dòng này - chuyển đổi String sang Status
        if (roleProfile.shopStatus != null) {
          shopStatus.value = Status.fromString(roleProfile.shopStatus!);
        }
        // Nếu không có từ roleProfile, giữ nguyên giá trị từ fetchUserShop

        if (roleProfile.shipperStatus != null) {
          shipperStatus.value = Status.fromString(roleProfile.shipperStatus!);
        } else {
          shipperStatus.value = Status.INACTIVE;
        }
        // Thêm phần cập nhật trạng thái shipper
        if (roleProfile.shipperStatus != null) {
          shipperStatus.value = Status.fromString(roleProfile.shipperStatus!);
        }else{
          shipperStatus.value = Status.INACTIVE;
        }
      }
    } catch (e) {
      print("Error checking user roles: $e");
    }
  }
}






