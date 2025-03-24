import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/service/shipper_service.dart';
import '../../../models/order.dart';

class ShipperHomeController extends GetxController {
  final shipperId = 3; // 👈 hoặc lấy từ session
  var isBusy = false.obs;
  var orders = <Order>[].obs;

  //Status của order
  var doneOrders = 0.obs;
  var deliveringOrders = 0.obs;
  var ship_pendingOrders = 0.obs;

  //Những thứ khác
  var revenue = 0.0.obs;
  var totalEarnings = 0.0.obs;
  var userName = "Tung".obs;

  @override
  void onReady() {
    fetchOrders();
    super.onReady();
  }

  void toggleBusy(bool value) {
    isBusy.value = value;
    // Có thể call API đổi trạng thái nếu muốn
  }

  Future<void> fetchOrders() async {
    try {
      final result = await ShipperService().fetchOrdersByShipper(shipperId);
      orders.value = result;

      // Thống kê
      doneOrders.value = result.where((o) => o.status == "DELIVERED").length;
      deliveringOrders.value =
          result.where((o) => o.status == "SHIPPING").length;
      ship_pendingOrders.value =
          result.where((o) => o.status == "SHIP_PENDING").length;
      revenue.value = result.fold(0.0, (sum, o) => sum + (o.total));
    } catch (e) {
      print("❌ Lỗi lấy đơn hàng: $e");
    }
  }
}
