import 'package:get/get.dart';

import '../controllers/shop_voucher_list_controller.dart';

class ShopVoucherListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopVoucherListController>(
      () => ShopVoucherListController(),
    );
  }
}
