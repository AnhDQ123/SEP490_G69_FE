import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_banner_controller.dart';

class AddBannerView extends GetView<AddBannerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Thêm banner"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildImageUploadSection(),
        const Spacer(),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText(),
          const SizedBox(height: 8),
          _buildDescriptionText(),
          const SizedBox(height: 16),
          _buildImagePicker(),
        ],
      ),
    );
  }

  Widget _buildTitleText() {
    return Text(
      "Tải lên hình ảnh Banner *",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      "Banner là hình ảnh quảng cáo được xuất hiện trên trang chủ. "
          "Kích thước không được vượt quá 30MB. Định dạng: JPG/PNG.",
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Obx(() {
      return GestureDetector(
        onTap: controller.pickImage,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[400]!,
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: controller.imagePath.value.isEmpty
              ? _buildPlaceholder()
              : _buildImagePreview(),
        ),
      );
    });
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[500]),
        const SizedBox(height: 8),
        Text(
          "Nhấn để chọn ảnh",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(controller.imagePath.value),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        return ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.uploadBanner,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: Colors.blue[600],
          ),
          child: controller.isLoading.value
              ? _buildLoadingIndicator()
              : _buildButtonText(),
        );
      }),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildButtonText() {
    return const Text(
      "XÁC NHẬN TẢI LÊN",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}