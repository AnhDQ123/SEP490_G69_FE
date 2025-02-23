import 'package:get/get.dart';

class ImageViewerController extends GetxController {
  late List<String> mediaUrls;
  late int initialIndex;

  @override
  void onInit() {
    super.onInit();

    // Lấy dữ liệu từ Get.arguments, nếu null thì cung cấp giá trị mặc định
    mediaUrls = Get.arguments?["mediaUrls"] ?? [];
    initialIndex = Get.arguments?["index"] ?? 0;
  }
}