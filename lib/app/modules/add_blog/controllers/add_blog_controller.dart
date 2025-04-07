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

  // Gọi BlogService để tạo blog mới
  Future<void> submitBlog() async {
    final content = contentController.text.trim();
    if (content.isEmpty && selectedAssets.isEmpty) return;

    // Chuyển đổi các AssetEntity thành File
    List<File> files = [];
    for (var asset in selectedAssets) {
      final file = await asset.file;
      files.add(file!); // Đảm bảo file không null
    }

    try {
      isLoading.value = true; // Bắt đầu loading
      // Gọi service để tạo blog
      final blogService = BlogService();
      await blogService.addBlog(content, files); // Tạo blog mới

      // Khi tạo blog thành công
      isLoading.value = false; // Dừng loading
      Get.snackbar('Thành công', 'Bài viết đã được đăng!');
      contentController.clear();
      selectedAssets.clear();

      // Quay lại trang Bloglist
      Get.back(); // Quay lại trang trước
    } catch (e) {
      // Nếu có lỗi
      isLoading.value = false; // Dừng loading
      Get.snackbar('Lỗi', 'Đã có lỗi xảy ra khi tạo bài viết');
      print(e);
    }
  }
}
