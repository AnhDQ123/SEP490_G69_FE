import 'package:get/get.dart';
import '../../../models/order.dart';
import '../../../service/order_service.dart';

class CheckOutController extends GetxController {
  final OrderService orderService = OrderService();

  var orders = <Order>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  int? orderId; // chỉ 1 đơn
  var order = Rxn<Order>(); // đơn hiện tại
  @override
  void onInit() {
    super.onInit();
    // orderId = Get.arguments as int?;
    orderId = 21; // 👈 Gán cứng tại đây để test
    fetchOrder();
  }

  /// 🔁 Gọi từng đơn theo ID vì API không hỗ trợ list
  Future<void> fetchOrder() async {
    if (orderId == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedOrder = await orderService.fetchOrderById(orderId!);
      if (fetchedOrder != null) {
        order.value = fetchedOrder;
      } else {
        errorMessage.value = 'Không tìm thấy đơn hàng.';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  /// ✅ Đặt hàng
  Future<void> placeOrder(Order order) async {
    try {
      isLoading.value = true;
      final createdOrders = await orderService.createOrder(order);
      if (createdOrders.isNotEmpty) {
        Get.snackbar('Thành công', 'Đặt hàng thành công!',
            snackPosition: SnackPosition.BOTTOM);
        orders.assignAll(createdOrders);
      } else {
        Get.snackbar('Lỗi', 'Không tạo được đơn hàng',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
