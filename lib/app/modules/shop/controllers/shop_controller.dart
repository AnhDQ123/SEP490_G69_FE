import 'package:get/get.dart';

import '../../../service/shop_service.dart';

class ShopController extends GetxController {
  var isFreeShipping = false.obs; // RxBool
  var isShopClosed = false.obs; // RxBool

  var orderCounts = <String, int>{}.obs; // RxMap để lưu số lượng đơn

  @override
  void onInit() {
    super.onInit();
    fetchOrderCounts(1); // Gọi API khi khởi tạo controller, lấy dữ liệu cho shopId = 1
  }

  Future<void> fetchOrderCounts(int shopId) async {
    final result = await ShopService().fetchOrderCounts(shopId);

    if (result.isNotEmpty) {
      orderCounts.value = result; // Cập nhật giá trị vào RxMap
    }
  }
}
