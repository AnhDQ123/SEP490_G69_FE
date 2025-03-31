import 'package:get/get.dart';

import '../controllers/add_voucher_controller.dart';

class AddVoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddVoucherController>(
      () => AddVoucherController(),
    );
  }
}
