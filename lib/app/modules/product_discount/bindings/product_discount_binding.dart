import 'package:get/get.dart';

import '../controllers/product_discount_controller.dart';

class ProductDiscountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDiscountController>(
      () => ProductDiscountController(),
    );
  }
}
