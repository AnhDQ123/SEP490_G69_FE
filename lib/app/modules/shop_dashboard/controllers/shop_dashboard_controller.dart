import 'package:get/get.dart';

import '../../../service/dashboard_service.dart';
import '../../shop_menu/controllers/shop_controller.dart';

class ShopDashboardController extends GetxController {
  // Biến cho dữ liệu theo tháng
  var orders_S = <Map<String, dynamic>>[].obs;  // Đơn hàng thành công theo tháng
  var orders_F = <Map<String, dynamic>>[].obs;  // Đơn hàng thất bại theo tháng

  // Biến cho dữ liệu theo ngày
  var orders_S_Daily = <Map<String, dynamic>>[].obs; // Đơn hàng thành công theo ngày
  var orders_F_Daily = <Map<String, dynamic>>[].obs; // Đơn hàng thất bại theo ngày

  var topProducts = <Map<String, dynamic>>[].obs; // Top sản phẩm bán chạy
  var isLoading = true.obs;
  var selectedChartType = 'monthly'.obs; // 'monthly' hoặc 'daily'
  var shopId = Get.find<ShopController>().shopId;

  final DashboardService dashboardService = DashboardService();

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      // Gọi đồng thời tất cả API
      final results = await Future.wait([
        dashboardService.fetchOrdersByStatusByMonth(shopId, "DELIVERED"),
        dashboardService.fetchOrdersByStatusByMonth(shopId, "REJECTED"),
        dashboardService.fetchOrdersByStatusByMonth(shopId, "CANCELLED"),
        dashboardService.fetchOrdersByStatusByDay(shopId, "DELIVERED"),
        dashboardService.fetchOrdersByStatusByDay(shopId, "REJECTED"),
        dashboardService.fetchOrdersByStatusByDay(shopId, "CANCELLED"),
        dashboardService.fetchTopSellingProductsByMonth(shopId),
      ]);

      // Xử lý dữ liệu theo tháng
      orders_S.assignAll(results[0]);
      final failedMonthlyOrders = [...results[1], ...results[2]];
      orders_F.assignAll(_combineOrders(failedMonthlyOrders, isDaily: false));

      // Xử lý dữ liệu theo ngày
      orders_S_Daily.assignAll(results[3]);
      final failedDailyOrders = [...results[4], ...results[5]];
      orders_F_Daily.assignAll(_combineOrders(failedDailyOrders, isDaily: true));

      // Top sản phẩm
      topProducts.assignAll(results[6]);

    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu dashboard: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> _combineOrders(
      List<Map<String, dynamic>> orders, {
        required bool isDaily,
      }) {
    final combined = <String, Map<String, dynamic>>{};
    final keyField = isDaily ? 'date' : 'month';

    for (var order in orders) {
      final key = order[keyField].toString();
      if (combined.containsKey(key)) {
        combined[key]!['orderCount'] += order['orderCount'];
      } else {
        combined[key] = {...order};
      }
    }

    return combined.values.toList()
      ..sort((a, b) => a[keyField].compareTo(b[keyField]));
  }

  void toggleChartType(String type) {
    selectedChartType.value = type;
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }
}