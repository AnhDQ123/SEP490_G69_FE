import 'package:get/get.dart';

import '../controllers/shop_register_controller.dart';

class ShopRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopRegisterController>(
      () => ShopRegisterController(),
    );
  }
}
