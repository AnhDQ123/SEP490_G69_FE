import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_detail_controller.dart';

class FeedbackDialog extends StatefulWidget {
  final int productId;

  const FeedbackDialog({Key? key, required this.productId}) : super(key: key);

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final List<String> _images = [];
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Viết đánh giá'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Đánh giá sao
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            // Nhập nội dung
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Nội dung đánh giá',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            // Tải lên ảnh (tùy chọn)
            // ... Thêm widget upload ảnh ở đây nếu cần
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _rating == 0 ? null : _submitFeedback,
          child: _isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Gửi đánh giá'),
        ),
      ],
    );
  }

  Future<void> _submitFeedback() async {
    if (_rating == 0) return;

    setState(() => _isSubmitting = true);

    try {
      // Gọi controller để xử lý submit
      final success = await Get.find<ProductDetailController>().submitFeedback(
        rating: _rating,
        comment: _feedbackController.text,
        imageUrls: _images,
      );

      if (success) {
        Get.back(); // Đóng dialog
        Get.snackbar('Thành công', 'Đã gửi đánh giá thành công');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Gửi đánh giá thất bại: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}