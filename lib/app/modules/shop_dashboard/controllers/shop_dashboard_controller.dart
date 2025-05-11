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
        dashboardService.fetchOrdersByStatusByMonth(shopId, "RETURN_REJECTED"),
        dashboardService.fetchOrdersByStatusByDay(shopId, "DELIVERED"),
        dashboardService.fetchOrdersByStatusByDay(shopId, "REJECTED"),
        dashboardService.fetchOrdersByStatusByDay(shopId, "CANCELLED"),
        dashboardService.fetchOrdersByStatusByDay(shopId, "RETURN_REJECTED"),
        dashboardService.fetchTopSellingProductsByMonth(shopId),
      ]);

      // Xử lý dữ liệu theo tháng
      final successMonthlyOrders = [...results[0], ...results[3]];
      orders_S.assignAll(_combineOrders(successMonthlyOrders, isDaily: false));
      final failedMonthlyOrders = [...results[1], ...results[2]];
      orders_F.assignAll(_combineOrders(failedMonthlyOrders, isDaily: false));

      // Xử lý dữ liệu theo ngày
      final successDailyOrders = [...results[4], ...results[7]];
      orders_S_Daily.assignAll(_combineOrders(successDailyOrders, isDaily: true));
      final failedDailyOrders = [...results[5], ...results[6]];
      orders_F_Daily.assignAll(_combineOrders(failedDailyOrders, isDaily: true));

      // Top sản phẩm
      topProducts.assignAll(results[8]);

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