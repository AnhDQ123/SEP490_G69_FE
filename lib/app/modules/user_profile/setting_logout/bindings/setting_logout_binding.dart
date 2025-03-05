import 'package:get/get.dart';

import '../controllers/setting_logout_controller.dart';

class SettingLogoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingLogoutController>(
      () => SettingLogoutController(),
    );
  }
}
