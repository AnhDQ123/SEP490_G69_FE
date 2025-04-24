import 'package:get/get.dart';

import '../controllers/google_map_page_controller.dart';

class GoogleMapPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleMapPageController>(
      () => GoogleMapPageController(),
    );
  }
}
