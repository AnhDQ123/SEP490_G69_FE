import 'package:get/get.dart';
import '../../../models/order.dart';
import '../../../service/shipper_service.dart';

class ShipperOrderDetailController extends GetxController {
  late final int orderId;
  late final List<Order> orders;
  final Rxn<Order> order = Rxn<Order>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    orderId = args['orderId'];
    orders = args['orders'];

    // ✅ Lấy ra đúng Order từ list
    order.value = orders.firstWhereOrNull((o) => o.id == orderId);
  }

  Future<void> acceptOrder(int userId) async {
    if (order.value == null) return;

    final result = await ShipperService().acceptShipping(
      orderId: order.value!.id,
      userId: userId,
    );

    if (result.success) {
      order.value!.status = 'SHIPPING';
      order.refresh();

      // ✅ Trả đơn hàng mới về để màn danh sách xử lý tiếp
      Get.back(result: order.value);
    } else {
      Get.snackbar("❌ Thất bại", result.message);
    }
  }
}
