import 'package:get/get.dart';

import '../controllers/recommended_products_controller.dart';

class RecommendedProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecommendedProductsController>(
      () => RecommendedProductsController(),
    );
  }
}
