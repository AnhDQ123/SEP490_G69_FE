
import 'package:get/get.dart';
import '../../../models/order.dart';
import '../../../service/order_service.dart';

class CheckOutController extends GetxController {
  final OrderService orderService = OrderService();

  // Danh sách đơn hàng được lấy từ API
  var orders = <Order>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  List<int> orderIds = [19,20];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedOrders = await orderService.fetchOrders(orderIds);
      orders.assignAll(fetchedOrders);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

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

