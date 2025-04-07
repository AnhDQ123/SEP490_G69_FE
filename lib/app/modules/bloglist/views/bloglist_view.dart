import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/blog.dart';
import '../../../routes/app_pages.dart';
import '../controllers/bloglist_controller.dart';

class BloglistView extends StatelessWidget {
  final BloglistController controller = Get.put(BloglistController());
  final imageController = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Bạn đang nghĩ gì?",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          onTap: () {
                            _showAddBlogBottomSheet();
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.photo_library),
                        onPressed: () {
                          imageController.pickMedia();
                        },
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Quản lý bài đăng của bạn"),
                  ),
                ],
              ),
            ),
          ),
          Divider(),

          // Danh sách bài đăng cuộn xuống cùng phần đầu
          Obx(() {
            if (controller.blogs.isEmpty) {
              return Center(child: Text("Không có bài viết nào!"));
            }
            return ListView.builder(
              shrinkWrap: true, // Đảm bảo nó không chiếm toàn bộ không gian
              physics: NeverScrollableScrollPhysics(), // Tránh lỗi cuộn kép
              itemCount: controller.blogs.length,
              itemBuilder: (context, index) {
                final blog = controller.blogs[index];
                return BlogCard(blog: blog);
              },
            );
          }),
        ],
      ),
    );
  }

}

class BlogCard extends StatelessWidget {
  final Blog blog;
  BlogCard({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ngăn blog dưới bị kéo dài
          children: [
             Row(
                children: [
                  CircleAvatar(child: Icon(Icons.person)),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(blog.writer.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(blog.createdAt), style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Spacer(),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_horiz),
                    onSelected: (value) {},
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text("Chỉnh sửa"),
                        ]),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Xóa"),
                        ]),
                      ),
                      PopupMenuItem(
                        value: 'report',
                        child: Row(children: [
                          Icon(Icons.flag, color: Colors.orange),
                          SizedBox(width: 8),
                          Text("Báo cáo"),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 10),
            // Nội dung Blog (nếu có)

            if (blog.content != null)
              GestureDetector(
                onTap: () => Get.toNamed(Routes.BLOGDETAIL, arguments: blog),
                child: Container(
                  width: double.infinity, // Giúp khoảng trống có thể bấm được
                  padding: EdgeInsets.symmetric(vertical: 5), // Tạo vùng bấm rộng hơn
                  child: Text(
                    blog.content!,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),


            SizedBox(height: 10),
            // Hiển thị ảnh
            if (blog.imageUrls.isNotEmpty)
              GestureDetector(
                onTap: () => Get.toNamed(
                  Routes.IMAGE_VIEWER,
                  arguments: {'images': blog.imageUrls, 'index': 0},
                ),
                child: _buildMediaGrid(blog.imageUrls),
              ),
            SizedBox(height: 10),
            // Nút Like, Comment, Share
            Row(
              children: [
                _buildInteractionButton(Icons.favorite_border, () {
                print("Đã thích bài viết của ${blog.writer.name}");
                }),
                SizedBox(width: 10),
                _buildInteractionButton(Icons.comment, () {
                  Get.toNamed("/blogdetail", arguments: blog);
                }),
                SizedBox(width: 10),
                _buildInteractionButton(Icons.send, () {
                print("Chia sẻ bài viết của ${blog.writer.name}");
                }
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Widget tạo các nút tương tác
Widget _buildInteractionButton(IconData icon, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Icon(icon, size: 25, color: Colors.grey[700]),
      ],
    ),
  );
}
}

void _showAddBlogBottomSheet() {
  final imageController = Get.put(ImagePickerController());

  Get.bottomSheet(
    Container(
      height: MediaQuery.of(Get.context!).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thanh tiêu đề với Avatar & Tên người dùng
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nguyen Son Tung",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          Divider(),

          // Ô nhập nội dung
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: "Hãy chia sẻ trải nghiệm của bạn!",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hiển thị ảnh/video đã chọn
          Obx(() {
            return imageController.selectedMedia.isNotEmpty
                ? Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageController.selectedMedia.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(imageController.selectedMedia[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () {
                            imageController.selectedMedia.removeAt(index);
                          },
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
                : SizedBox();
          }),

          SizedBox(height: 10),

          // Các tùy chọn bổ sung (Ảnh, Camera, Vị trí, Cảm xúc)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildOptionRow(Icons.photo_library, "Ảnh/video", () {
                  imageController.pickMedia();
                }),
                _buildOptionRow(Icons.emoji_emotions, "Cảm xúc cá nhân", () {
                  _showEmojiPicker(Get.context!);
                }),
                _buildOptionRow(Icons.location_on, "Thêm vị trí", () {}),
                _buildOptionRow(Icons.camera_alt, "Camera", () {
                  imageController.captureImage();
                }),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Nút Đăng bài
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  imageController.selectedMedia.clear(); // Xóa toàn bộ ảnh/video đã chọn
                  Get.back(); // Đóng BottomSheet
                  Get.snackbar("Thông báo", "Bài viết đã được đăng!");
                },
                child: Text("Đăng bài"),
              ),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

Widget _buildOptionRow(IconData icon, String text, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );
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

final TextEditingController _textController = TextEditingController();
void _showEmojiPicker(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          height: 250,
          width: double.maxFinite,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              int cursorPos = _textController.selection.baseOffset;
              if (cursorPos < 0) cursorPos = _textController.text.length;

              String newText = _textController.text.substring(0, cursorPos) +
                  emoji.emoji +
                  _textController.text.substring(cursorPos);

              _textController.text = newText;
              _textController.selection = TextSelection.fromPosition(
                TextPosition(offset: cursorPos + emoji.emoji.length),
              );

              Navigator.pop(context);
            },
            config: Config(
              emojiViewConfig: EmojiViewConfig(
                emojiSizeMax: 32, // Kích thước emoji
                noRecents: const Text('Không có emoji gần đây'),
              ),
              skinToneConfig: SkinToneConfig(),
              categoryViewConfig: CategoryViewConfig(),
            ),
          ),
        ),
      );
    },
  );
}

