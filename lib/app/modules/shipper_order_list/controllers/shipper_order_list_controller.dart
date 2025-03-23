import 'package:get/get.dart';
import '../../../models/order.dart';
import '../../../service/shipper_service.dart';

class ShipperOrderListController extends GetxController {
  final RxString selectedStatus = 'SHIP_PENDING'.obs;
  final RxList<Order> orders = <Order>[].obs;

  List<Order> get filteredOrders =>
      orders.where((o) => o.status == selectedStatus.value).toList();

  void setStatus(String status) {
    selectedStatus.value = status;
  }

  Future<void> refreshOrders() async {
    try {
      final updated = await ShipperService().fetchOrdersByShipper(3);
      orders.assignAll(updated);        // Cập nhật danh sách
      orders.refresh();                 // ⚠️ BẮT BUỘC: thông báo Obx rebuild lại
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể làm mới danh sách đơn hàng");
    }
  }


  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    final List<Order> receivedOrders = args['orders'] ?? [];
    final String initialStatus = args['status'] ?? 'SHIP_PENDING';

    orders.assignAll(receivedOrders);
    selectedStatus.value = initialStatus;
  }

  Future<void> handleAcceptOrder(Order order, int userId) async {
    final service = ShipperService();
    final result = await service.acceptShipping(orderId: order.id, userId: userId);

    if (result.success) {
      final index = orders.indexWhere((o) => o.id == order.id);
      orders[index].status = 'SHIPPING'; // ✅ Cập nhật trạng thái
      orders.refresh();                  // ✅ Trigger UI update cho Obx
      Get.snackbar("✅ Thành công", "Đơn hàng đã được xác nhận!");
    } else {
      Get.snackbar("❌ Lỗi", result.message);
    }
  }

  void updateOrderInList(Order updated) {
    final index = orders.indexWhere((o) => o.id == updated.id);
    if (index != -1) {
      orders[index] = updated;
      orders.refresh(); // 🔄 Cập nhật Obx UI
    }
  }


}
