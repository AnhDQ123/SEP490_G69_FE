import 'package:get/get.dart';

import '../controllers/shop_dashboard_controller.dart';

class ShopDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopDashboardController>(
      () => ShopDashboardController(),
    );
  }
}
