import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/blog.dart';

class BlogService {
  // final String baseUrl = 'http://10.0.2.2:8080/api'; // địa chỉ cho giả lập
  final String baseUrl = 'http://192.168.1.16:8080/api';

  Future<List<Blog>> fetchBlogs() async {
    final response = await http.get(Uri.parse('$baseUrl/blogs'));

    if (response.statusCode == 200) {
      // ✅ Giải mã UTF-8 để xử lý tiếng Việt
      final decodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = jsonDecode(decodedBody);
      return jsonList.map((json) => Blog.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<void> addBlog(String content, List<File> files) async {
    try {
      final uri = Uri.parse('$baseUrl/blogs'); // Địa chỉ API tạo blog

      // Tạo một request multipart để gửi dữ liệu form
      var request = http.MultipartRequest('POST', uri);

      // Thêm nội dung bài viết
      request.fields['id'] = '1';
      request.fields['content'] = content;

      // Thêm các tệp đính kèm
      for (var file in files) {
        final multipartFile = await http.MultipartFile.fromPath(
          'files', file.path,
        );
        request.files.add(multipartFile);
      }

      // Gửi yêu cầu POST
      final response = await request.send();

      if (response.statusCode == 201) {
        // Được tạo thành công
        print('Blog created successfully');
      } else {
        throw Exception('Failed to create blog');
      }
    } catch (e) {
      print('Error creating blog: $e');
      throw Exception('Failed to create blog');
    }
  }
}
