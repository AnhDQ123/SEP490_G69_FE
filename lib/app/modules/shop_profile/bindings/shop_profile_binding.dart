import 'package:get/get.dart';

import '../controllers/shop_profile_controller.dart';

class ShopProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopProfileController>(
      () => ShopProfileController(),
    );
  }
}
