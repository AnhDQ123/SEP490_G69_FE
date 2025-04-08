import 'package:get/get.dart';

import '../controllers/shipper_order_list_controller.dart';

class ShipperOrderListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShipperOrderListController>(
      () => ShipperOrderListController(),
    );
  }
}
