import 'package:get/get.dart';

import '../controllers/product_selection_controller.dart';

class ProductSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductSelectionController>(
      () => ProductSelectionController(),
    );
  }
}
