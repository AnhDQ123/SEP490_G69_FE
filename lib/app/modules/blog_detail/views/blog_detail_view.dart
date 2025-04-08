import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../controllers/blog_detail_controller.dart';

class BlogDetailView extends GetView<BlogDetailController> {
  const BlogDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với thông tin người đăng
            _buildBlogHeader(),
            SizedBox(height: 16),
            // Nội dung blog
            _buildBlogContent(),
            SizedBox(height: 24),
            // Phần comment
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: controller.blog.writer.avatarUrl != null
              ? NetworkImage(controller.blog.writer.avatarUrl!)
              : AssetImage('assets/default_avatar.png') as ImageProvider,
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.blog.writer.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${controller.blog.createdAt.day}/${controller.blog.createdAt.month}/${controller.blog.createdAt.year}',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBlogContent() {
    final context = Get.context; // or Get.context!
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.blog.content,
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 16),
        if (controller.blog.imageUrls.isNotEmpty)
          _buildImageGrid(controller.blog.imageUrls, context!),
      ],
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
                imageProvider: NetworkImage(controller.blog.imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            itemCount: controller.blog.imageUrls.length,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: initialIndex),
            onPageChanged: (index) {},
          ),
        ),
      ),
    );
  }


  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments (${controller.blog.commentCount})',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        // Danh sách comment (có thể thay bằng ListView.builder nếu có dữ liệu thật)
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Comment feature will be implemented soon'),
        ),
      ],
    );
  }
}