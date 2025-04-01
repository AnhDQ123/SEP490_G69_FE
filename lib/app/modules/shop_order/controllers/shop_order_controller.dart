import 'package:get/get.dart';
import '../../../models/order.dart';
import '../../../service/order_service.dart';

class ShopOrderController extends GetxController {
  late final int shopId;
  final isLoading = true.obs;
  final currentIndex = 0.obs;

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
    shopId = Get.arguments ?? 1; //shopid
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      isLoading.value = true;

      pending.assignAll(await _orderService.fetchOrdersByShopAndStatus(id: shopId, status: "PENDING"));
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
