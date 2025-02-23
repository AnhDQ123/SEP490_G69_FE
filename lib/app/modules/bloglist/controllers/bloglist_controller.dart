import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BloglistController extends GetxController {
  var blogs = <Blog>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }

  void fetchBlogs() {
    blogs.assignAll([
      Blog(
        author: "Hoang Hai Dang",
        date: "05/02/2025 10:03",
        content: "Welcome to ThichBunCa. Nếu bạn đang tìm kiếm một trải nghiệm Việt Nam đích thực, đừng tìm đâu xa! Tại ThichBunCa...",
        mediaUrls: ["img.png"],
      ),
      Blog(
        author: "Nguyen Minh Nhat",
        date: "05/01/2025 9:03",
        content: "bun bo",
        mediaUrls: ["img_3.png", "img_4.png"],
      ),
      Blog(
        author: "Nguyen Minh Nhat",
        date: "05/01/2025 9:03",
        content: "bun bo",
        mediaUrls: ["img_3.png", "img_4.png","img_5.png"],
      ),
      Blog(
        author: "Nguyen Minh Nhat",
        date: "05/01/2025 9:03",
        content: "bun bo",
        mediaUrls: ["img_3.png", "img_4.png","img_5.png","img_1.png"],
      ),
      Blog(
        author: "Nguyen Minh Nhat",
        date: "05/01/2025 9:03",
        content: "bun bo",
        mediaUrls: ["img.png", "img_4.png","img_5.png","img_4.png","img_2.png"],
      )
    ]);
  }
}

class Blog {
  final String author;
  final String date;
  final String? content;
  final List<String> mediaUrls;

  Blog({
    required this.author,
    required this.date,
    this.content,
    required this.mediaUrls,
  });
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


