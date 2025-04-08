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
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text.rich(
          TextSpan(
            text: 'Tạo Blog',
            style: TextStyle(fontSize: 20, color: Colors.black87),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Obx(() {
            if (controller.isLoading.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TextButton(
                  onPressed: controller.submitBlog,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  child: const Text('ĐĂNG'),
                ),
              );
            }
          }),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // Phần nội dung có thể cuộn
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info and prompt
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/default_avatar.png'),
                          radius: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Người dùng",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Chia sẻ trải nghiệm của bạn",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Content text field
                    TextField(
                      controller: controller.contentController,
                      maxLines: null,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Hãy viết điều gì đó thú vị...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selected media grid
                    Obx(() {
                      if (controller.selectedAssets.isEmpty) {
                        return const SizedBox();
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: controller.selectedAssets.length,
                        itemBuilder: (context, index) {
                          final asset = controller.selectedAssets[index];
                          return FutureBuilder<File?>(
                            future: asset.file,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return _buildLoadingIndicator();
                              }
                              final file = snapshot.data!;
                              final isVideo = asset.type == AssetType.video;

                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: isVideo
                                        ? FutureBuilder<Uint8List?>(
                                      future: asset.thumbnailDataWithSize(
                                        const ThumbnailSize(500, 500),
                                      ),
                                      builder: (context, thumbSnapshot) {
                                        if (!thumbSnapshot.hasData) {
                                          return _buildLoadingIndicator();
                                        }
                                        return Image.memory(
                                          thumbSnapshot.data!,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                        : Image.file(
                                      file,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (isVideo)
                                    const Center(
                                      child: Icon(
                                        Icons.play_circle_filled,
                                        size: 40,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => controller.removeAsset(index),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Phần icon cố định ở dưới (không bị đẩy lên bởi bàn phím)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    const Divider(height: 1),
                    _buildVerticalIconButton(Icons.photo_library, "Ảnh/video", Colors.green, () => controller.pickAssets()),
                    _buildVerticalIconButton(Icons.emoji_emotions, "Cảm xúc cá nhân", Colors.amber, () {}),
                    // _buildVerticalIconButton(Icons.location_on, "Thêm vị trí", Colors.red, () {}),
                    _buildVerticalIconButton(Icons.camera_alt, "Camera", Colors.purple, () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
    );
  }

  Widget _buildVerticalIconButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}