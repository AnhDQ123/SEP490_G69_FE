import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../models/blog.dart';
import '../../../routes/app_pages.dart';
import '../controllers/bloglist_controller.dart';

class BloglistView extends GetView<BloglistController> {
  const BloglistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blogs'), centerTitle: true),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.fetchBlogs,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.blogs.length + 1, // +1 để chèn CreatePostSection
            itemBuilder: (context, index) {
              if (index == 0) return const CreatePostSection(); // 👈 ô "Bạn đang nghĩ gì?"
              final blog = controller.blogs[index - 1];
              return BlogCard(blog: blog);
            },
          ),
        );
      }),
    );
  }
}

class CreatePostSection extends StatelessWidget {
  const CreatePostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed('/add-blog'),
              child: Row(
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
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed('/add-blog'),
              child: const Text(
                "Quản lý bài đăng của bạn",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BlogCard extends StatelessWidget {
  final Blog blog;

  const BlogCard({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info (unchanged)
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: blog.writer.avatarUrl != null
                      ? NetworkImage(blog.writer.avatarUrl!)
                      : const AssetImage('assets/default_avatar.png')
                  as ImageProvider,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.writer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(blog.createdAt),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Blog content (unchanged)
            Text(
              blog.content,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),

            // Images if available (unchanged)
            if (blog.imageUrls.isNotEmpty) ...[
              _buildImageGrid(blog.imageUrls, context),
              const SizedBox(height: 12),
            ],

            // Footer with action buttons (updated)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Like button
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.favorite_border, size: 18),
                    label: Text('0'), // Replace with actual like count
                    onPressed: () {
                      // Handle like action
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),

                // Comment button
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.comment, size: 18),
                    label: Text('${blog.commentCount}'),
                    onPressed: () => Get.toNamed(
                      R0outes.BLOG_DETAIL,
                      arguments: blog,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                    ),
                  ),
                ),

                // Share button
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share'),
                    onPressed: () {
                      // Handle share action
                      _shareBlog(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<String> imageUrls, BuildContext context) {
    final count = imageUrls.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.6;

    Widget buildContent() {
      switch (count) {
        case 1:
          return GestureDetector(
            onTap: () => _openImageGallery(context, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrls[0],
                width: double.infinity,
                height: imageHeight * 1.2,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    _buildImageLoader(child, loadingProgress),
                errorBuilder: (context, error, stackTrace) => _buildImageError(),
              ),
            ),
          );

        case 2:
          return SizedBox(
            height: imageHeight,
            child: Row(
              children: [
                _buildGridImage(imageUrls[0], flex: 1, height: imageHeight, index: 0),
                const SizedBox(width: 4),
                _buildGridImage(imageUrls[1], flex: 1, height: imageHeight, index: 1),
              ],
            ),
          );

        case 3:
          return SizedBox(
            height: imageHeight,
            child: Row(
              children: [
                _buildGridImage(imageUrls[0], flex: 3, height: imageHeight, index: 0),
                const SizedBox(width: 4),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildGridImage(imageUrls[1], height: imageHeight / 2 - 2, index: 1),
                      const SizedBox(height: 4),
                      _buildGridImage(imageUrls[2], height: imageHeight / 2 - 2, index: 2),
                    ],
                  ),
                ),
              ],
            ),
          );

        case 4:
          return SizedBox(
            height: imageHeight,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildGridImage(imageUrls[0], flex: 1, height: imageHeight / 2, index: 0),
                      const SizedBox(width: 4),
                      _buildGridImage(imageUrls[1], flex: 1, height: imageHeight / 2, index: 1),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Row(
                    children: [
                      _buildGridImage(imageUrls[2], flex: 1, height: imageHeight / 2, index: 2),
                      const SizedBox(width: 4),
                      _buildGridImage(imageUrls[3], flex: 1, height: imageHeight / 2, index: 3),
                    ],
                  ),
                ),
              ],
            ),
          );

        default: // 5+ images
          return SizedBox(
            height: imageHeight * 1.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - 2 images
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildGridImage(imageUrls[0], height: imageHeight * 0.75, index: 0),
                      const SizedBox(height: 4),
                      _buildGridImage(imageUrls[1], height: imageHeight * 0.75, index: 1),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                // Right column - 3 images
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildGridImage(imageUrls[2], height: imageHeight * 0.5, index: 2),
                      const SizedBox(height: 4),
                      _buildGridImage(imageUrls[3], height: imageHeight * 0.5, index: 3),
                      const SizedBox(height: 4),
                      _buildGridImage(imageUrls[4], height: imageHeight * 0.5, index: 4),
                    ],
                  ),
                ),
              ],
            ),
          );
      }
    }

    return GestureDetector(
      onTap: () => _openImageGallery(context, 0),
      child: buildContent(),
    );
  }

  Widget _buildGridImage(String imageUrl, {int flex = 1, double? height, int? index}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () {
          if (index != null) {
            _openImageGallery(Get.context!, index);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            height: height,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) => _buildImageLoader(child, loadingProgress),
            errorBuilder: (context, error, stackTrace) => _buildImageError(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageLoader(Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.error, color: Colors.red),
      ),
    );
  }

  void _shareBlog(BuildContext context) {
    // Implement share functionality
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy link'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share via...'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement native share dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openImageGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(blog.imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            itemCount: blog.imageUrls.length,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: initialIndex),
            onPageChanged: (index) {},
          ),
        ),
      ),
    );
  }


}