import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';
import '../models/comment.dart';

class CommentService {
  final String baseUrl = ApiBaseUrl.baseUrl;

  Future<List<Comment>> fetchComments({
    required int blogId,
    int page = 0,     // ✅ Trang số (page index, bắt đầu từ 0)
  }) async {
    final uri = Uri.parse('$baseUrl/api/comments/$blogId?offset=$page');
    print('🌐 Fetching comments from: $uri');

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final String utf8Body = utf8.decode(response.bodyBytes); // 👈 Giải mã UTF-8
      final List<dynamic> data = jsonDecode(utf8Body);

      print('📦 Response decoded (${data.length}): $data');

      return data.map((e) => Comment.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải bình luận (status ${response.statusCode})');
    }
  }


  Future<void> postComment({
    required int blogId,
    required String content,
    required int writerId,
  }) async {
    final url = Uri.parse('$baseUrl/api/comments/$blogId');

    final body = jsonEncode({
      'content': content,
      'writer': { // 👈 Thêm thông tin writer
        'id': writerId,
      },
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể tạo bình luận');
    }
  }

  Future<void> deleteComment(int commentId) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/comments/$commentId'));
    if (response.statusCode != 200) {
      throw Exception('Không thể xoá bình luận');
    }
  }


}