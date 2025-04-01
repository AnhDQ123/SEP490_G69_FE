import 'package:get/get.dart';

import '../controllers/user_view_shop_detail_controller.dart';

class UserViewShopDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserViewShopDetailController>(
      () => UserViewShopDetailController(),
    );
  }
}
