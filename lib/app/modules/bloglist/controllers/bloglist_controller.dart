import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/blog.dart';
import '../../../services/blog_services.dart';

class BloglistController extends GetxController {
  var blogs = <Blog>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }


  Future<void> fetchBlogs() async {
    try {
      final blogService = BlogService();
      blogs.value = await blogService.fetchBlogs();
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

}


class ImagePickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Danh sách ảnh/video đã chọn
  var selectedMedia = <File>[].obs;

  // Chọn ảnh hoặc video từ thư viện
  Future<void> pickMedia() async {
    final List<XFile>? pickedFiles = await _picker.pickMultipleMedia();

    // Nếu người dùng chọn ảnh/video
    if (pickedFiles != null) {
      if (pickedFiles.length + selectedMedia.length > 5) {
        Get.snackbar("Lỗi", "Bạn chỉ có thể chọn tối đa 5 ảnh/video!");
        return;
      }
      selectedMedia.addAll(pickedFiles.map((file) => File(file.path)));
    }
  }

  // Mở camera để chụp ảnh
  Future<void> captureImage() async {
    final XFile? capturedFile = await _picker.pickImage(source: ImageSource.camera);

    // Nếu người dùng chọn ảnh/video
    if (capturedFile != null) {
      if (selectedMedia.length >= 5) {
        Get.snackbar("Lỗi", "Bạn chỉ có thể chọn tối đa 5 ảnh/video!");
        return;
      }
      selectedMedia.add(File(capturedFile.path));
    }
  }

  // Bộ chọn emoji
  var selectedEmoji = "".obs; // Lưu emoji đã chọn
  var isEmojiPickerVisible = false.obs; // Ẩn/hiện emoji picker

  void setEmoji(String emoji) {
    selectedEmoji.value += emoji; // Thêm emoji vào chuỗi
  }

  void toggleEmojiPicker() {
    isEmojiPickerVisible.value = !isEmojiPickerVisible.value;
  }
}


