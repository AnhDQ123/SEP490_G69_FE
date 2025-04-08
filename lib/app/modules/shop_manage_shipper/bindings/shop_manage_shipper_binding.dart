import 'package:get/get.dart';

import '../controllers/shop_manage_shipper_controller.dart';

class ShopManageShipperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopManageShipperController>(
      () => ShopManageShipperController(),
    );
  }
}
