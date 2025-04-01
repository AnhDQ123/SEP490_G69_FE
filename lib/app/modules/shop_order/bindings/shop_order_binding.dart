import 'package:get/get.dart';

import '../controllers/shop_order_controller.dart';

class ShopOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopOrderController>(
      () => ShopOrderController(),
    );
  }
}
