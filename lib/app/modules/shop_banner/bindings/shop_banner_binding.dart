import 'package:get/get.dart';

import '../controllers/shop_banner_controller.dart';

class ShopBannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopBannerController>(
      () => ShopBannerController(),
    );
  }
}
