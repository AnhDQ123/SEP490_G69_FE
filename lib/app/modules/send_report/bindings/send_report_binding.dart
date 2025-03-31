import 'package:get/get.dart';

import '../controllers/send_report_controller.dart';

class SendReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendReportController>(
      () => SendReportController(),
    );
  }
}
