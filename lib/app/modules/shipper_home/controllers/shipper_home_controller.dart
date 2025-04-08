import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/service/shipper_service.dart';
import '../../../models/order.dart';
import '../../../models/user_profile.dart';
import '../../../service/user_service.dart';

class ShipperHomeController extends GetxController {
  late final int userId; // Sử dụng kiểu int thường
  var isBusy = false.obs;
  var orders = <Order>[].obs;

  //Status của order
  var doneOrders = 0.obs;
  var deliveringOrders = 0.obs;
  var ship_pendingOrders = 0.obs;

  //Những thứ khác
  var revenue = 0.0.obs;
  var totalEarnings = 0.0.obs;
  var userName = "".obs;
  final UserService _userService = UserService();
  var isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    userId = arguments?['userId'] ?? 0;
    userName.value = arguments?['userName'] ?? ""; // Nhận tên từ arguments

    if (userId <= 0) {
      Get.snackbar("Lỗi", "Không tìm thấy thông tin shipper");
      Future.delayed(Duration.zero, () => Get.back());
      return;
    }
    fetchUserProfile(); // Thêm hàm này
    fetchOrders();
  }

  Future<void> fetchUserProfile() async {
    try {
      UserProfile? profile = await _userService.fetchUserProfile(userId);
      if (profile != null) {
        userName.value = profile.name;
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin user: $e");
    }
  }


  Future<void> toggleBusyStatus(bool isBusy) async {
    try {
      final response = isBusy
          ? await ShipperService().setShipperBusy(userId)
          : await ShipperService().setShipperAvailable(userId);

      if (response.success) {
        this.isBusy.value = isBusy;
        Get.snackbar("Thành công", response.message);
      } else {
        Get.snackbar("Lỗi", response.message);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Có lỗi xảy ra: ${e.toString()}");
    }finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchOrders() async {
    try {
      isBusy.value = true;
      final result = await ShipperService().fetchOrdersByShipper(userId);
      orders.value = result;

      // Thống kê
      doneOrders.value = result.where((o) => o.status == "DELIVERED").length;
      deliveringOrders.value = result.where((o) => o.status == "SHIPPING").length;
      ship_pendingOrders.value = result.where((o) => o.status == "SHIP_PENDING").length;
      revenue.value = result.fold(0.0, (sum, o) => sum + (o.total));
    } catch (e) {
      print("❌ Lỗi lấy đơn hàng: $e");
      Get.snackbar("Lỗi", "Không thể tải dữ liệu đơn hàng");
    } finally {
      isBusy.value = false;
    }
  }
}
