import 'package:get/get.dart';

import '../controllers/blogdetail_controller.dart';

class BlogdetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogDetailController>(
      () => BlogDetailController(),
    );
  }
}
