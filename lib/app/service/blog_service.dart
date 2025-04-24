import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';
import '../base/base_common.dart';
import '../models/blog.dart';

class BlogService {
  final String baseUrl = ApiBaseUrl.baseUrl;

  Future<List<Blog>> fetchBlogs(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/api/blogs?page=$page'));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = jsonDecode(decodedBody);
      return jsonList.map((json) => Blog.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<void> addBlog(String content, List<File> files, int writerId) async {
    try {
      final uri = Uri.parse('$baseUrl/api/blogs');

      var request = http.MultipartRequest('POST', uri);

      // Thêm các trường form đúng như backend mong đợi
      request.fields['content'] = content;
      request.fields['writer.id'] = writerId.toString();

      // Thêm file ảnh nếu có
      for (var file in files) {
        final multipartFile = await http.MultipartFile.fromPath(
          'files', file.path,
        );
        request.files.add(multipartFile);
      }

      // Gửi request
      final response = await request.send();

      if (response.statusCode == 201) {
        print('Blog created successfully');
      } else {
        final respStr = await response.stream.bytesToString();
        print('Failed with status: ${response.statusCode}');
        print('Response body: $respStr');
        throw Exception('Failed to create blog');
      }
    } catch (e) {
      print('Error creating blog: $e');
      throw Exception('Failed to create blog');
    }
  }

  Future<void> deleteBlog(int blogId) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/blogs/$blogId'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete blog');
    }
  }

  Future<void> updateBlog({
    required int blogId,
    required String content,
    required List<String> imageUrls,
    required List<File> files,
  }) async {
    final uri = Uri.parse('$baseUrl/api/blogs/$blogId');
    final request = http.MultipartRequest('PUT', uri);

    request.fields['content'] = content;
    request.fields['writer.id'] = BaseCommon.instance.userId ?? '0';

    // Gửi imageUrls[] trong form
    for (int i = 0; i < imageUrls.length; i++) {
      request.fields['imageUrls[$i]'] = imageUrls[i];
    }

    // Gửi files mới
    for (var file in files) {
      final multipartFile = await http.MultipartFile.fromPath('files', file.path);
      request.files.add(multipartFile);
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Cập nhật blog thất bại');
    }
  }


}