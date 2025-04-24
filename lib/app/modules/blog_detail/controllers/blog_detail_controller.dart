import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/base_common.dart';
import '../../../models/blog.dart';
import '../../../models/comment.dart';
import '../../../service/comment_service.dart';

class BlogDetailController extends GetxController {
  late Blog blog;
  var currentPage = 0.obs;
  var hasMoreComments = true.obs; // Còn comment để load không

  var comments = <Comment>[].obs;
  var isLoadingComments = false.obs;

  final CommentService _commentService = CommentService();
  final isPostingComment = false.obs;

  final currentUserId = int.tryParse(BaseCommon.instance.userId ?? '0');

  @override
  void onInit() {
    super.onInit();
    blog = Get.arguments as Blog;
    print('🧠 Nhận blog từ arguments: blogId = ${blog.id}');
    fetchComments();
  }

  Future<void> fetchComments({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        currentPage.value = 0;
        isLoadingComments.value = true;
        print('🔄 Bắt đầu tải bình luận (Trang đầu tiên)');
      } else {
        print('🔄 Đang tải thêm bình luận (Trang ${currentPage.value + 1})');
      }

      final result = await _commentService.fetchComments(
        blogId: blog.id,
        page: currentPage.value,
      );

      print('✅ Nhận được ${result.length} bình luận từ trang ${currentPage.value}');
      print('📊 Thông số phân trang:');
      print('- Trang hiện tại: ${currentPage.value}');
      print('- Số bình luận hiện có: ${comments.length}');
      print('- Số bình luận mới nhận: ${result.length}');

      if (!loadMore) {
        comments.clear();
        print('🆕 Làm mới danh sách bình luận');
      }

      comments.addAll(result);
      hasMoreComments.value = result.isNotEmpty;

      if (result.isNotEmpty) {
        currentPage.value++;
        print('⏭️ Chuyển sang trang ${currentPage.value} cho lần tải tiếp theo');
      } else {
        print('⏹️ Đã tải hết tất cả bình luận');
      }

      print('📌 Tổng số bình luận hiện tại: ${comments.length}');
    } catch (e) {
      print('❌ Lỗi khi tải bình luận trang ${currentPage.value}: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải thêm bình luận',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingComments.value = false;
    }
  }
  Future<void> loadMoreComments() async {
    if (!isLoadingComments.value && hasMoreComments.value) {
      await fetchComments(loadMore: true);
    }
  }


  Future<void> postComment(String content) async {
    try {
      isPostingComment.value = true;
      print('Đang đăng bình luận...');
      print('Blog ID: ${blog.id}');
      print('Writer ID: ${int.parse(BaseCommon.instance.userId ?? '0')}');
      print('Nội dung bình luận: $content');
      await _commentService.postComment(
        blogId: blog.id,
        content: content,
        writerId: int.parse(BaseCommon.instance.userId ?? '0'), // Convert to int, default to 0 if null
      );

      Get.snackbar(
        'Thành công',
        'Đã đăng bình luận',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600]!.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      blog.commentCount = (blog.commentCount ?? 0) + 1;

      fetchComments(); // Làm mới danh sách bình luận
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể đăng bình luận: ${e.toString().replaceAll("Exception: ", "")}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600]!.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      print('❌ Lỗi khi post comment: $e');
    } finally {
      isPostingComment.value = false;
    }
  }

  Future<void> deleteCommentById(int commentId) async {
    try {
      await _commentService.deleteComment(commentId);

      // Xoá khỏi danh sách comment
      comments.removeWhere((c) => c.id == commentId);

      // Giảm số lượng comment trên blog
      blog.commentCount = (blog.commentCount ?? 1) - 1;

      Get.snackbar(
        'Thành công',
        'Đã xoá bình luận',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[600]!.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xoá bình luận: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600]!.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }


}