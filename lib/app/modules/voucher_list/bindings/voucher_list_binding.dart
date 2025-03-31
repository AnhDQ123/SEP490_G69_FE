import 'package:get/get.dart';

import '../controllers/voucher_list_controller.dart';

class VoucherListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoucherListController>(
      () => VoucherListController(),
    );
  }
}
