import 'package:get/get.dart';

import '../../../models/shop_profile.dart';
import '../../../service/shop_service.dart';

class ShopController extends GetxController {
  var isFreeShipping = false.obs; // RxBool
  var isShopClosed = false.obs; // RxBool

  var orderCounts = <String, int>{}.obs; // RxMap để lưu số lượng đơn

  int shopId = 1;
  var shopInfo = Rx<ShopProfile?>(null);


  @override
  void onInit() {
    super.onInit();
    fetchOrderCounts(shopId);
    fetchShopInfo(shopId);
  }

  Future<void> fetchShopInfo(int shopId) async {
    try {
      final shop = await ShopService().fetchShopProfile(shopId);
      shopInfo.value = shop;
    } catch (e) {
      print('❌ Lỗi khi lấy thông tin shop: $e');
    }
  }


  Future<void> fetchOrderCounts(int shopId) async {
    final result = await ShopService().fetchOrderCounts(shopId);

    if (result.isNotEmpty) {
      orderCounts.value = result; // Cập nhật giá trị vào RxMap
    }
  }


}
