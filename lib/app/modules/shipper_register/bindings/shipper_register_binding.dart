import 'package:get/get.dart';

import '../controllers/shipper_register_controller.dart';

class ShipperRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShipperRegisterController>(
      () => ShipperRegisterController(),
    );
  }
}
