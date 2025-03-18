import 'package:get/get.dart';
import '../../../models/order.dart';
import '../../../service/order_service.dart';

class MyOrderController extends GetxController {
  var currentIndex = 4.obs;
  var isLoading = true.obs;

  final pendingOrders = <Order>[].obs;
  final preparingOrders = <Order>[].obs;
  final shippingOrders = <Order>[].obs;
  final deliveredOrders = <Order>[].obs;
  final canceledOrders = <Order>[].obs;
  final returnedOrders = <Order>[].obs;

  final OrderService _orderService = OrderService(); // Dùng OrderService

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;

      List<int> orderIds = [1, 2, 3, 4, 5]; // 🔹 Danh sách ID thực tế
      List<Order> orders = await _orderService.fetchOrders(orderIds);

      print("📦 Đã nhận ${orders.length} đơn hàng từ API");

      // 🔹 Phân loại đơn hàng theo trạng thái
      pendingOrders.assignAll(orders.where((o) => o.shipMethodId == 1));
      preparingOrders.assignAll(orders.where((o) => o.shipMethodId == 2));
      shippingOrders.assignAll(orders.where((o) => o.shipMethodId == 3));
      deliveredOrders.assignAll(orders.where((o) => o.shipMethodId == 4));
      canceledOrders.assignAll(orders.where((o) => o.shipMethodId == 5));
      returnedOrders.assignAll(orders.where((o) => o.shipMethodId == 6));

    } catch (e) {
      print("❌ Lỗi khi loadOrders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
