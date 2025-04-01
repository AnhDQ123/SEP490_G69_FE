import 'package:get/get.dart';

import '../controllers/shop_report_controller.dart';

class ShopReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopReportController>(
      () => ShopReportController(),
    );
  }
}
