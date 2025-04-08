import 'package:get/get.dart';
import '../../../models/blog.dart';

class BlogDetailController extends GetxController {
  final Blog blog = Get.arguments as Blog;

  @override
  void onInit() {
    super.onInit();
    // Có thể thêm các xử lý khởi tạo ở đây
  }
}