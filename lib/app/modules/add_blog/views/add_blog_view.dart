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
                        Obx(() => CircleAvatar(
                          backgroundImage: controller.avatarUrl.value.isNotEmpty
                              ? NetworkImage(controller.avatarUrl.value)
                              : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          radius: 22,
                        )),
                        const SizedBox(width: 12),
                        Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.userName.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )),
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
                      final hasOld = controller.existingImageUrls.isNotEmpty;
                      final hasNew = controller.selectedAssets.isNotEmpty;

                      if (!hasOld && !hasNew) {
                        return const SizedBox();
                      }

                      final totalCount = controller.existingImageUrls.length + controller.selectedAssets.length;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: totalCount,
                        itemBuilder: (context, index) {
                          if (index < controller.existingImageUrls.length) {
                            // 👉 ẢNH CŨ (từ server)
                            final imageUrl = controller.existingImageUrls[index];
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => controller.removeExistingImage(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
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
                          } else {
                            // 👉 ẢNH MỚI (từ picker)
                            final assetIndex = index - controller.existingImageUrls.length;
                            final asset = controller.selectedAssets[assetIndex];
                            return FutureBuilder<File?>(
                              future: asset.file,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return _buildLoadingIndicator();
                                final file = snapshot.data!;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(file, fit: BoxFit.cover),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => controller.removeAsset(assetIndex),
                                        child: Container(
                                          decoration: const BoxDecoration(
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
                          }
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