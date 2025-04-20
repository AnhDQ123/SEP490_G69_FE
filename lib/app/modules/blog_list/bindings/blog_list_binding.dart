import 'package:get/get.dart';

import '../controllers/blog_list_controller.dart';

class BlogListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogListController>(
      () => BlogListController(),
    );
  }
}
