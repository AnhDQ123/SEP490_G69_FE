import 'package:get/get.dart';

import '../controllers/shop_add_product_controller.dart';

class ShopAddProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopAddProductController>(
      () => ShopAddProductController(),
    );
  }
}
