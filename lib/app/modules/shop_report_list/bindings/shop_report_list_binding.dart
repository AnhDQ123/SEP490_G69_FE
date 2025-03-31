import 'package:get/get.dart';

import '../controllers/shop_report_list_controller.dart';

class ShopReportListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopReportListController>(
      () => ShopReportListController(),
    );
  }
}
