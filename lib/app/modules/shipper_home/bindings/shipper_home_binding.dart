import 'package:get/get.dart';

import '../controllers/shipper_home_controller.dart';

class ShipperHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShipperHomeController>(
      () => ShipperHomeController(),
    );
  }
}
