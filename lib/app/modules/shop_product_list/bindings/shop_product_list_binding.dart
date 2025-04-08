import 'package:get/get.dart';

import '../controllers/shop_product_list_controller.dart';

class ShopProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopProductListController>(
      () => ShopProductListController(),
    );
  }
}
