import 'package:get/get.dart';
import '../../../service/dashboard_service.dart';


class ShopDashboardController extends GetxController {
  var orders = <Map<String, dynamic>>[].obs;  // Danh sách đơn hàng
  var isLoading = true.obs;  // Trạng thái loading

  final DashboardService dashboardService = DashboardService();

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  // Hàm lấy đơn hàng từ API
  void loadOrders() async {
    isLoading.value = true;  // Bắt đầu loading
    try {
      final result = await dashboardService.getShopOrdersByMonth(1); // Giả sử shopId = 1
      orders.assignAll(result);  // Cập nhật danh sách đơn hàng
      print(orders);
    } catch (e) {
      print("Error loading orders: $e");
    } finally {
      isLoading.value = false;  // Kết thúc loading
    }
  }
}
