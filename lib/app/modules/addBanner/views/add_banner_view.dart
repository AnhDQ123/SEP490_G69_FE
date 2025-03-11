import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_banner_controller.dart';

class AddBannerView extends GetView<AddBannerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm banner"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tải lên hình ảnh Banner *",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Banner là hình ảnh quảng cáo được xuất hiện trên trang chủ, sau khi tải lên sẽ được chờ duyệt để hiển thị. Kích thước không được vượt quá 30MB.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: controller.imagePath.value.isEmpty
                          ? Icon(Icons.add, size: 50, color: Colors.grey)
                          : Image.file(
                        File(controller.imagePath.value),
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: controller.uploadBanner,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("Xác nhận", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
