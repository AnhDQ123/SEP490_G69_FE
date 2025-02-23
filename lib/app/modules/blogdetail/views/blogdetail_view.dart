import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/blogdetail_controller.dart';

class BlogdetailView extends StatelessWidget {
  final BlogDetailController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết Blog")),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 60), // Dưới dành chỗ cho input
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị Blog
                  Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.blog.author, style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(controller.blog.date, style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 10),
                          Text(controller.blog.content ?? "", style: TextStyle(color: Colors.black54)),
                          SizedBox(height: 10),
                          if (controller.blog.mediaUrls.isNotEmpty)
                            _buildMediaGrid(controller.blog.mediaUrls),
                        ],
                      ),
                    ),
                  ),

                  Divider(),

                  // Danh sách bình luận
                  Obx(() {
                    return ListView.builder(
                      itemCount: controller.comments.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // Tránh lỗi cuộn trong cuộn
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(child: Icon(Icons.person)),
                          title: Text(controller.comments[index]),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          // Ô nhập bình luận cố định dưới đáy
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      // controller: controller.commentController,
                      decoration: InputDecoration(
                        hintText: "Nhập bình luận...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0), // customize the border radius here
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      // if (controller.commentController.text.isNotEmpty) {
                      //   // controller.addComment(controller.commentController.text);
                      //   // controller.commentController.clear(); // Xóa nội dung sau khi gửi
                      }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


Widget _buildMediaGrid(List<String> mediaUrls) {
  int count = mediaUrls.length;

  switch (count) {
    case 1:
      return AspectRatio(
        aspectRatio: 16 / 9, // Hiển thị theo kích thước tự nhiên
        child: _buildImage(mediaUrls[0], mediaUrls, BoxFit.cover, 0),
      );

    case 2:
      return Row(
        children: [
          Expanded(child: _buildImage(mediaUrls[0], mediaUrls, BoxFit.cover,0)),
          SizedBox(width: 5),
          Expanded(child: _buildImage(mediaUrls[1], mediaUrls, BoxFit.cover,1)),
        ],
      );

    case 3:
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: _buildImage(mediaUrls[0], mediaUrls, BoxFit.cover, 0),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: _buildImage(mediaUrls[1], mediaUrls, BoxFit.cover, 1)),
              SizedBox(width: 5),
              Expanded(child: _buildImage(mediaUrls[2], mediaUrls, BoxFit.cover, 2)),
            ],
          ),
        ],
      );

    case 4:
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildImage(mediaUrls[0], mediaUrls, BoxFit.cover, 0)),
              SizedBox(width: 5),
              Expanded(child: _buildImage(mediaUrls[1], mediaUrls, BoxFit.cover, 1)),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: _buildImage(mediaUrls[0], mediaUrls, BoxFit.cover, 2)),
              SizedBox(width: 5),
              Expanded(child: _buildImage(mediaUrls[1], mediaUrls, BoxFit.cover, 3)),
            ],
          ),
        ],
      );

    case 5:
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildImage(mediaUrls[0], mediaUrls, BoxFit.cover, 0)),
              SizedBox(width: 5),
              Expanded(child: _buildImage(mediaUrls[1], mediaUrls, BoxFit.cover, 1)),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: _buildImageSmall(mediaUrls[2], mediaUrls, BoxFit.cover, 2)),
              SizedBox(width: 5),
              Expanded(child: _buildImageSmall(mediaUrls[3], mediaUrls, BoxFit.cover, 3)),
              SizedBox(width: 5),
              Expanded(child: _buildImageSmall(mediaUrls[4], mediaUrls, BoxFit.cover, 4)),
            ],
          ),
        ],
      );

    default:
      return SizedBox();
  }
}

Widget _buildImage(String imageUrl, List<String> mediaUrls, BoxFit fit, int index) {
  return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.IMAGE_VIEWER, arguments: {
          "mediaUrls": mediaUrls, // Truyền toàn bộ danh sách ảnh
          "index": index, // Truyền index ảnh đang chọn
        });
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage("assets/images/$imageUrl"),
            fit: fit,
          ),
        ),
      )
  );
}

Widget _buildImageSmall(String imageUrl, List<String> mediaUrls, BoxFit fit, int index) {
  return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.IMAGE_VIEWER, arguments: {
          "mediaUrls": mediaUrls, // Truyền toàn bộ danh sách ảnh
          "index": index, // Truyền index ảnh đang chọn
        });
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage("assets/images/$imageUrl"),
            fit: fit,
          ),
        ),
      )
  );
}

