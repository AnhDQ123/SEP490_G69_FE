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
  final returnPendingOrders = <Order>[].obs;
  final returnedOrders = <Order>[].obs;
  final rejectedOrders = <Order>[].obs;
  final shipPendingOrders = <Order>[].obs;
  final returnRejectedOrders = <Order>[].obs;

  final OrderService _orderService = OrderService(); // Dùng OrderService

  late int userId; // Thêm biến userId

  @override
  void onInit() {
    super.onInit();
    final int userId = Get.arguments as int;  // Chỉ cần nhận userId là int
    this.userId = userId;  // Lưu vào biến userId
    loadOrders();
  }



  Future<void> loadOrders() async {
    try {
      isLoading.value = true;

      // Gọi API cho từng trạng thái và assign vào các danh sách tương ứng
      pendingOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "PENDING"));
      preparingOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "PROCESSING"));
      shippingOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "SHIPPING"));
      deliveredOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "DELIVERED"));
      canceledOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "CANCELLED"));
      returnPendingOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "RETURN_PENDING"));
      returnedOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "RETURNED"));
      rejectedOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "REJECTED"));
      shipPendingOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "SHIP_PENDING"));
      returnRejectedOrders.assignAll(await _orderService.fetchOrdersByOwnerAndStatus(id: userId, status: "RETURN_REJECTED"));

      print("📦 Đã nhận các đơn hàng theo trạng thái từ API");
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
