import 'package:get/get.dart';

import '../controllers/shipper_order_detail_controller.dart';

class ShipperOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShipperOrderDetailController>(
      () => ShipperOrderDetailController(),
    );
  }
}
