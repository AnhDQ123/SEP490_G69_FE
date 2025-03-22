import 'package:get/get.dart';

import '../controllers/return_order_detail_page_controller.dart';

class ReturnOrderDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReturnOrderDetailController>(
      () => ReturnOrderDetailController(),
    );
  }
}
