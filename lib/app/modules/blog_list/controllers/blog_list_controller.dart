import 'dart:io';
import 'package:ffb_fe_flutter/app/modules/user_profile/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_common.dart';
import '../../../models/blog.dart';
import '../../../models/user_profile.dart';
import '../../../service/blog_service.dart';
import '../../../service/user_service.dart';

class BlogListController extends GetxController {
  var isLoading = false.obs;
  var currentPage = 0.obs; // Biến theo dõi trang hiện tại

  var blogs = <Blog>[].obs;
  var bottomNavIndex = 0.obs;

  final UserService _userService = UserService();
  var userName = "".obs;
  var avatarUrl = "".obs;

  late ScrollController _scrollController; // Thêm ScrollController

  ScrollController get scrollController =>
      _scrollController; // Getter cho _scrollController

  @override
  void onInit() {
    super.onInit();
    _scrollController = ScrollController(); // Khởi tạo ScrollController
    _scrollController.addListener(_scrollListener); // Lắng nghe sự kiện cuộn
    fetchData();
  }

  // Lắng nghe sự kiện cuộn
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreBlogs(); // Nếu cuộn đến cuối danh sách, tải thêm blog
    }
  }

  // Hàm này sẽ được gọi để tải dữ liệu ban đầu và tải thêm khi cần
  Future<void> fetchData() async {
    isLoading.value = true;
    blogs.value = <Blog>[];
    currentPage.value = 0;

    await Future.wait([
      fetchBlogs(currentPage.value),
      fetchProfile(),
    ]);

    isLoading.value = false;
  }

  Future<void> fetchBlogs(int page) async {
    try {
      final blogService = BlogService();
      final newBlogs = await blogService.fetchBlogs(page);
      if (page == 0) {
        blogs.value =
            newBlogs; // Lần đầu tải dữ liệu, thay thế hoàn toàn danh sách
      } else {
        blogs.addAll(
            newBlogs); // Nếu không phải lần đầu thì thêm vào danh sách hiện tại
      }
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

  Future<void> fetchProfile() async {
    print("⚠️ (debug) Bắt đầu fetchProfile");
    try {
      final userIdStr = BaseCommon.instance.userId;
      if (userIdStr == null) {
        Get.offAllNamed('/login');
        return;
      }

      final userId = int.tryParse(userIdStr);
      if (userId == null) {
        Get.offAllNamed('/login');
        return;
      }

      UserProfile? profile = await _userService.fetchUserProfile(userId);
      if (profile != null) {
        userName.value = profile.name;
        avatarUrl.value = profile.avatar ?? '';
      }
    } catch (e, stackTrace) {
      print("❌ (debug) Lỗi khi fetchProfile: $e");
      print(stackTrace);
      Get.snackbar('Lỗi', 'Không thể tải thông tin profile: ${e.toString()}');
    }
  }

  // Hàm tải thêm blog khi người dùng kéo xuống
  void loadMoreBlogs() {
    if (isLoading.value) return; // Nếu đang tải thì không làm gì
    currentPage.value++; // Cập nhật trang hiện tại
    fetchBlogs(
        currentPage.value); // Gọi lại API để tải blog của trang tiếp theo
  }
}