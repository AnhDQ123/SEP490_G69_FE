import 'package:get/get.dart';

import '../../../service/map_service.dart';
import '../controllers/google_map_page_controller.dart';

class GoogleMapPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapService());  // Đăng ký MapService
    Get.lazyPut<GoogleMapPageController>(
      () => GoogleMapPageController(),
    );
  }
}
