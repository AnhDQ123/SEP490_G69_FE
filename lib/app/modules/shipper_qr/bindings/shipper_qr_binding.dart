import 'package:get/get.dart';

import '../controllers/shipper_qr_controller.dart';

class ShipperQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShipperQrController>(
      () => ShipperQrController(),
    );
  }
}
