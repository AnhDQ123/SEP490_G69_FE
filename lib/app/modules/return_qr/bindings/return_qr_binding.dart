import 'package:get/get.dart';

import '../controllers/return_qr_controller.dart';

class ReturnQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReturnQrController>(
      () => ReturnQrController(),
    );
  }
}
