import 'package:get/get.dart';
import '../../../models/order.dart';
import '../../../service/notification_service.dart';
import '../../../service/order_service.dart';

class ShopOrderController extends GetxController {
  late final int shopId;
  final isLoading = true.obs;
  final currentIndex = 0.obs;
  final scannedOrderIds = <int>{}.obs;


  final pending = <Order>[].obs;
  final processing = <Order>[].obs;
  final shipping = <Order>[].obs;
  final shipPending = <Order>[].obs;
  final delivered = <Order>[].obs;
  final rejected = <Order>[].obs;
  final cancelled = <Order>[].obs;
  final returned = <Order>[].obs;
  final returnPending = <Order>[].obs; // 🔹 thêm mới
  final returnRejected = <Order>[].obs;


  final OrderService _orderService = OrderService();

  @override
  void onInit() {
    super.onInit();
    // Đảm bảo rằng shopId là kiểu int và được lấy chính xác
    shopId = Get.arguments != null && Get.arguments is Map<String, dynamic>
        ? Get.arguments['shopId'] ?? 1 // Nếu có giá trị thì lấy, nếu không thì mặc định là 1
        : 1; // Nếu Get.arguments là null hoặc không phải kiểu Map, mặc định là 1
    fetchAll();
  }


  Future<void> fetchAll() async {
    try {
      isLoading.value = true;

      pending.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "PENDING"));
      await NotificationService.showPendingOrdersNotification(pending.length);
      processing.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "PROCESSING"));
      shipping.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "SHIPPING"));
      shipPending.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "SHIP_PENDING"));
      delivered.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "DELIVERED"));
      rejected.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "REJECTED"));
      cancelled.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "CANCELLED"));
      returned.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "RETURNED"));
      returnPending.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "RETURN_PENDING")); // 🔹 thêm dòng này
      returnRejected.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "RETURN_REJECTED"));

    } catch (e) {
      print("❌ Lỗi load orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) => currentIndex.value = index;
}
