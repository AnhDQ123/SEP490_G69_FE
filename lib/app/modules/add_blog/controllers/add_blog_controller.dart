import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Thêm thư viện image_picker
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../services/blog_services.dart';

class AddBlogController extends GetxController {
  final contentController = TextEditingController();
  final selectedAssets = <AssetEntity>[].obs;
  var isLoading = false.obs; // Trạng thái loading

  Future<void> pickAssets() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      PhotoManager.openSetting(); // Mở setting nếu không được cấp quyền
      return;
    }

    final result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 5, // Gioi han so luong anh
        requestType: RequestType.all, // Chi nhap anh
        selectedAssets: [], // Anh da chon
      ),
    );

    if (result != null) {
      selectedAssets.clear();
      selectedAssets.addAll(result); // Lưu các asset đã chọn
    }
  }

  void removeAsset(int index) {
    selectedAssets.removeAt(index);
  }

  Future<void> submitBlog() async {
    final content = contentController.text.trim();

    // Validate dữ liệu
    if (content.isEmpty && selectedAssets.isEmpty) {
      Get.snackbar(
        'Thiếu thông tin',
        'Vui lòng nhập nội dung hoặc thêm ảnh/video',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Chuyển đổi AssetEntity thành File
      final files = await Future.wait(
          selectedAssets.map((asset) async => (await asset.file)!)
      );

      // Gọi API tạo blog
      await BlogService().addBlog(content, files);

      // Xử lý thành công
      Get.back(); // Đóng màn hình hiện tại trước khi hiển thị thông báo

      // Hiển thị thông báo thành công
      Get.snackbar(
        'Thành công',
        'Bài viết đã được đăng thành công!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600]!.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: true,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );

      // Reset form
      contentController.clear();
      selectedAssets.clear();

    } catch (e) {
      // Xử lý lỗi
      Get.snackbar(
        'Lỗi',
        'Đăng bài thất bại: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600]!.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      print('Lỗi khi đăng bài: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
