import 'package:get/get.dart';

import '../controllers/add_banner_controller.dart';

class AddBannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBannerController>(
      () => AddBannerController(),
    );
  }
}
