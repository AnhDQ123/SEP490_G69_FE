import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../base/base_common.dart';
import '../../../models/blog.dart';
import '../../../service/blog_service.dart';

class AddBlogController extends GetxController {
  final contentController = TextEditingController();
  final selectedAssets = <AssetEntity>[].obs;
  var isLoading = false.obs;

  var avatarUrl = ''.obs;
  var userName = ''.obs;

  var isEditing = false.obs;
  Blog? editingBlog;
  var existingImageUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      avatarUrl.value = arguments['avatarUrl'] ?? '';
      userName.value = arguments['name'] ?? 'Người dùng';

      // 👇 Check nếu đang chỉnh sửa blog
      if (arguments['blog'] != null && arguments['blog'] is Blog) {
        isEditing.value = true;
        editingBlog = arguments['blog'];
        contentController.text = editingBlog!.content;
        existingImageUrls.assignAll(editingBlog!.imageUrls);
      }
    }
  }


  Future<void> pickAssets() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      PhotoManager.openSetting();
      return;
    }

    final result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 5,
        requestType: RequestType.all,
        selectedAssets: [],
      ),
    );

    if (result != null) {
      final onlyImages = result.where((asset) => asset.type == AssetType.image).toList();
      final hasVideo = result.any((asset) => asset.type == AssetType.video);

      if (hasVideo) {
        Get.snackbar(
          'Không hỗ trợ video',
          'Ứng dụng hiện tại chỉ hỗ trợ đăng ảnh.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        );
      }

      selectedAssets.clear();
      selectedAssets.addAll(onlyImages);
    }
  }


  void removeAsset(int index) {
    selectedAssets.removeAt(index);
  }

  void removeExistingImage(int index) {
    existingImageUrls.removeAt(index);
  }


  Future<void> submitBlog() async {
    final content = contentController.text.trim();

    if (content.isEmpty && selectedAssets.isEmpty && existingImageUrls.isEmpty) {
      Get.snackbar(
        'Thiếu thông tin',
        'Vui lòng nhập nội dung hoặc thêm ảnh',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final files = await Future.wait(
        selectedAssets.map((asset) async => (await asset.file)!),
      );

      final userId = int.parse(BaseCommon.instance.userId ?? '0');

      if (isEditing.value && editingBlog != null) {
        await BlogService().updateBlog(
          blogId: editingBlog!.id,
          content: content,
          imageUrls: existingImageUrls.toList(),
          files: files,
        );
      } else {
        await BlogService().addBlog(
          content,
          files,
          userId,
        );
      }

      Get.back();

      contentController.clear();
      selectedAssets.clear();
      existingImageUrls.clear();

      Get.snackbar(
        'Thành công',
        isEditing.value ? 'Đã cập nhật bài viết' : 'Bài viết đã được đăng thành công!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600]!.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Gửi blog thất bại: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600]!.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      print('❌ submitBlog error: $e');
    } finally {
      isLoading.value = false;
    }
  }


}