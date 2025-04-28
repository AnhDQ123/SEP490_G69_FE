import 'package:get/get.dart';

import '../../../service/map_service.dart';
import '../controllers/user_map_controller.dart';

class UserMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapService());  // Đăng ký MapService
    Get.lazyPut<UserMapController>(
      () => UserMapController(),
    );
  }
}
