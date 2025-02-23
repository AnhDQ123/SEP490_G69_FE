import 'package:get/get.dart';
import '../controllers/bloglist_controller.dart';

class BloglistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BloglistController>(() => BloglistController());
  }
}
