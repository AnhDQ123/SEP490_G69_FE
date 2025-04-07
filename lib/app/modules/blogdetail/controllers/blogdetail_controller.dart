import 'package:get/get.dart';
import '../../../models/blog.dart';
import '../../bloglist/controllers/bloglist_controller.dart';

class BlogDetailController extends GetxController {
  final Blog blog = Get.arguments; // Nhận Blog từ BloglistView
  var comments = <String>[].obs;

  void addComment(String comment) {
    if (comment.isNotEmpty) {
      comments.add(comment);
    }
  }
}
