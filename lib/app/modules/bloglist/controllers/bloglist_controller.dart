import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../models/blog.dart';
import '../../../services/blog_services.dart';

class BloglistController extends GetxController {
  var blogs = <Blog>[].obs;

  final TextEditingController textController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }


  Future<void> fetchBlogs() async {
    try {
      final blogService = BlogService();
      blogs.value = await blogService.fetchBlogs();
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

}

