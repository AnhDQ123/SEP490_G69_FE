import 'package:get/get.dart';
import '../../../base/base_common.dart';
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

  final OrderService _orderService = OrderService();

  late int userId; // Thêm biến userId

  @override
  void onInit() {
    super.onInit();
    // Kiểm tra Get.arguments có giá trị hợp lệ không
    final arg = Get.arguments;
    if (arg != null) {
      userId = arg as int;
      print("✅ userId nhận được: $userId");
    } else {
      print("❌ Không có dữ liệu truyền qua arguments");
      userId = 0;  // Gán giá trị mặc định nếu không có dữ liệu
    }

    loadOrders();
  }



  Future<void> loadOrders() async {
    try {
      isLoading.value = true;

      // Đảm bảo userId không phải là null và có giá trị hợp lệ
      if (userId == 0) {
        print("❌ userId không hợp lệ!");
        return;  // Dừng quá trình nếu userId không hợp lệ
      }

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
