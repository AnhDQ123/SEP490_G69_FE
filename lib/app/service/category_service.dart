import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../base/api_base_url.dart';

class CategoryService {
  // Hàm lấy danh sách danh mục
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse("${ApiBaseUrl.baseUrl}/api/category"));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        String utf8Body = utf8.decode(response.bodyBytes);
        var jsonData = jsonDecode(utf8Body); // Kiểm tra xem đây có phải là JSON hợp lệ không

        print("Parsed JSON: $jsonData");

        // Truy cập vào trường 'content' để lấy danh sách danh mục
        var contentList = jsonData['content'];

        // Kiểm tra nếu contentList là một danh sách, rồi chuyển đổi
        if (contentList is List) {
          List<Category> categories = contentList
              .map((item) => Category.fromJson(item))
              .toList();

          return categories;
        } else {
          throw Exception('Content không phải là một danh sách');
        }
      } else {
        throw Exception("Lỗi khi tải danh mục. Mã lỗi: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi gọi API danh mục: $e");
      throw Exception("Lỗi khi gọi API danh mục: $e");
    }
  }

}