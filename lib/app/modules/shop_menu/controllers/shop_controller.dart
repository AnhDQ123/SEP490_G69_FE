import 'package:get/get.dart';

import '../../../models/shop_profile.dart';
import '../../../service/shop_service.dart';

class ShopController extends GetxController {
  var isFreeShipping = false.obs; // RxBool
  var isShopClosed = false.obs; // RxBool

  var orderCounts = <String, int>{}.obs; // RxMap để lưu số lượng đơn

  int shopId = 0;
  var shopInfo = Rx<ShopProfile?>(null);

  @override
  void onInit() {
    super.onInit();
    // Nhận arguments từ trang trước đó (ProfileView)
    final arguments = Get.arguments;
    if (arguments != null) {
      shopId = arguments['shopId'] ?? 0;
      fetchShopInfo(shopId); // Lấy thông tin cửa hàng
      fetchOrderCounts(shopId); // Lấy số lượng đơn hàng
    }
  }

  Future<void> fetchShopInfo(int shopId) async {
    try {
      final shop = await ShopService().fetchShopProfile(shopId);
      print(shopId);
      shopInfo.value = shop;
      isFreeShipping.value = shop.isShipping;
      isShopClosed.value = !shop.isOpening; // Nếu isOpening == false -> cửa hàng đang đóng
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

  Future<void> toggleShipping() async {
    try {
      await ShopService().toggleShopShippingStatus(shopId);
      isFreeShipping.toggle(); // Cập nhật local state
    } catch (e) {
      print('❌ Toggle shipping failed: $e');
    }
  }

  Future<void> toggleOpenStatus() async {
    try {
      await ShopService().toggleShopOpenStatus(shopId);
      isShopClosed.toggle(); // Cập nhật local state
    } catch (e) {
      print('❌ Toggle open status failed: $e');
    }
  }

}
