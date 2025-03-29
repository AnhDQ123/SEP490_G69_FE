import 'package:get/get.dart';

import '../controllers/shop_add_discount_controller.dart';

class ShopAddDiscountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopAddDiscountController>(
      () => ShopAddDiscountController(),
    );
  }
}
