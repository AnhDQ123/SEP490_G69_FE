import 'package:get/get.dart';

import '../controllers/qr_payment_controller.dart';

class QrPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrPaymentController>(
      () => QrPaymentController(),
    );
  }
}
