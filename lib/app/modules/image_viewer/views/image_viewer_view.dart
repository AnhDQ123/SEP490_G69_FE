import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/image_viewer_controller.dart';

class ImageViewerView extends GetView<ImageViewerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        itemCount: controller.mediaUrls.length,
        controller: PageController(initialPage: controller.initialIndex),
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              child: Image.asset(
                "assets/images/${controller.mediaUrls[index]}",
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
