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

  final ShipperService _shipperService = ShipperService();



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
    fetchShipperRevenue(); // Gọi API để lấy doanh thu ngay khi màn hình được khởi tạo

  }

  Future<void> fetchShipperRevenue() async {
    try {
      isLoading.value = true;
      final response = await _shipperService.getShipperRevenue(userId);
      print("API Response: ${response.message}");  // Kiểm tra phản hồi
      if (response.success) {
        // Loại bỏ văn bản "Doanh thu: " trước khi chuyển đổi thành số
        final revenueString = response.message.replaceAll(RegExp(r'[^\d]'), ''); // Loại bỏ tất cả ký tự không phải số
        totalEarnings.value = double.tryParse(revenueString) ?? 0.0;
        print("Updated Total Earnings: ${totalEarnings.value}");  // Kiểm tra sau khi cập nhật
      } else {
        Get.snackbar("Lỗi", response.message);
      }
    } catch (e) {
      print("❌ Lỗi khi lấy doanh thu: $e");
      Get.snackbar("Lỗi", "Không thể tải doanh thu.");
    } finally {
      isLoading.value = false;
    }
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
      print("🔄 Bắt đầu fetch đơn hàng...");
      isBusy.value = true;

      final result1 = await ShipperService().fetchOrdersByShipperAndStatus(userId,'SHIP_PENDING');
      final result2 = await ShipperService().fetchOrdersByShipperAndStatus(userId,'SHIPPING');
      final result3 = await ShipperService().fetchOrdersByShipperAndStatus(userId,'DELIVERED');


      orders.value = result1 + result2 + result3;

      // Thống kê
      doneOrders.value = result3.where((o) => o.status == "DELIVERED").length;
      deliveringOrders.value = result2.where((o) => o.status == "SHIPPING").length;
      ship_pendingOrders.value = result1.where((o) => o.status == "SHIP_PENDING").length;
      revenue.value = result3.fold(0.0, (sum, o) => sum + (o.total));

      print("📦 Đơn giao thành công: ${doneOrders.value}");
      print("🚚 Đơn đang giao: ${deliveringOrders.value}");
      print("⏳ Đơn chờ giao: ${ship_pendingOrders.value}");
      print("💰 Doanh thu: ${revenue.value.toStringAsFixed(2)}");
    } catch (e) {
      print("❌ Lỗi lấy đơn hàng: $e");
      Get.snackbar("Lỗi", "Không thể tải dữ liệu đơn hàng");
    } finally {
      isBusy.value = false;
      print("✅ Hoàn tất fetch đơn hàng.");
    }
  }

}
