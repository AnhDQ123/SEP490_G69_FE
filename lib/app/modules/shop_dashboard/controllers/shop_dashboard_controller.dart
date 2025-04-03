import 'package:get/get.dart';
import '../../../service/dashboard_service.dart';

class ShopDashboardController extends GetxController {
  var orders_S = <Map<String, dynamic>>[].obs;  // Đơn hàng thành công
  var orders_F = <Map<String, dynamic>>[].obs;  // Đơn hàng thất bại
  var topProducts = <Map<String, dynamic>>[].obs; // Top sản phẩm bán chạy
  var isLoading = true.obs;

  final DashboardService dashboardService = DashboardService();

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  // Hàm tổng hợp tất cả dữ liệu dashboard
  void loadDashboardData() async {
    isLoading.value = true;
    try {
      // Gọi đồng thời tất cả API cần thiết
      final results = await Future.wait([
        dashboardService.fetchOrdersByStatusByMonth(1, "DELIVERED"),
        dashboardService.fetchOrdersByStatusByMonth(1, "REJECTED"),
        dashboardService.fetchOrdersByStatusByMonth(1, "CANCELLED"),
        dashboardService.fetchTopSellingProductsByMonth(1),
      ]);

      // Xử lý đơn hàng thành công
      orders_S.assignAll(results[0]);

      // Kết hợp đơn hàng thất bại
      final failedOrders = [...results[1], ...results[2]];
      final combinedFailedOrders = _combineOrdersByMonth(failedOrders);
      orders_F.assignAll(combinedFailedOrders);

      // Xử lý top sản phẩm
      topProducts.assignAll(results[3]);

    } catch (e) {
      print("Error loading dashboard data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm helper để kết hợp đơn hàng theo tháng
  List<Map<String, dynamic>> _combineOrdersByMonth(List<Map<String, dynamic>> orders) {
    final Map<String, Map<String, dynamic>> combined = {};

    for (var order in orders) {
      final key = '${order['month']}-${order['year']}';
      if (combined.containsKey(key)) {
        combined[key]!['orderCount'] += order['orderCount'];
      } else {
        combined[key] = {
          'month': order['month'],
          'year': order['year'],
          'orderCount': order['orderCount'],
        };
      }
    }

    return combined.values.toList();
  }
}