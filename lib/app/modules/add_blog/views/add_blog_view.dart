import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../controllers/add_blog_controller.dart';

class AddBlogView extends GetView<AddBlogController> {
  const AddBlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        title: const Text.rich(
          TextSpan(
            text: 'Tạo ',
            children: [
              TextSpan(
                text: 'blog',
                style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/default_avatar.png'),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Bạn đang nghĩ gì?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.image, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed('/add-blog'),
              child: const Text(
                "Quản lý bài đăng của bạn",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 12),

            // TextField for content
            TextField(
              controller: controller.contentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Hãy chia sẻ trải nghiệm của bạn!',
                border: InputBorder.none,
              ),
            ),

            // Thêm ảnh/video nếu có
            Obx(() {
              if (controller.selectedAssets.isNotEmpty) {
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedAssets.length,
                    itemBuilder: (context, index) {
                      final asset = controller.selectedAssets[index];
                      return FutureBuilder<File?>(
                        future: asset.file,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox();
                          final file = snapshot.data!;
                          final isVideo = asset.type == AssetType.video; // Kiểm tra nếu là video

                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: isVideo
                                  // Hiển thị thumbnail video
                                      ? FutureBuilder<Uint8List?>(
                                    future: asset.thumbnailDataWithSize(
                                      const ThumbnailSize(200, 200),
                                    ),
                                    builder: (context, thumbSnapshot) {
                                      if (!thumbSnapshot.hasData) {
                                        return const SizedBox();
                                      }
                                      return Image.memory(
                                        thumbSnapshot.data!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                  // Hiển thị ảnh bình thường
                                      : Image.file(
                                    file,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isVideo)
                                const Positioned(
                                  bottom: 4,
                                  right: 12,
                                  child: Icon(Icons.videocam, color: Colors.white),
                                ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => controller.removeAsset(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox(); // Không có ảnh/video chọn
              }
            }),


            const Spacer(),

            // Bottom action buttons and submit button
            Column(
              children: [
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomAction(Icons.photo, 'Ảnh/video', controller.pickAssets),
                    _bottomAction(Icons.emoji_emotions, 'Cảm xúc', () {}),
                    _bottomAction(Icons.location_on, 'Vị trí', () {}),
                    _bottomAction(Icons.camera_alt, 'Camera', () {}),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.submitBlog, // Gọi hàm submitBlog khi nhấn nút
                  child: const Text('Đăng bài'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
