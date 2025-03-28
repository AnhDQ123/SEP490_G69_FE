import 'package:get/get.dart';

import '../controllers/add_discount_controller.dart';

class AddDiscountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDiscountController>(
      () => AddDiscountController(),
    );
  }
}
