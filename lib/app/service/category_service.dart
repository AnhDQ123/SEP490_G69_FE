import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  static const String baseUrl = "http://10.0.2.2:8080/api/category"; // URL API category

  // Hàm lấy danh sách danh mục
  static Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        String utf8Body = utf8.decode(response.bodyBytes);
        var jsonData = jsonDecode(utf8Body); // Kiểm tra xem đây có phải là JSON hợp lệ không

        print("Parsed JSON: $jsonData");

        List<Category> categories = (jsonData as List)
            .map((item) => Category.fromJson(item))
            .toList();

        return categories;
      } else {
        throw Exception("Lỗi khi tải danh mục. Mã lỗi: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi gọi API danh mục: $e");
      throw Exception("Lỗi khi gọi API danh mục: $e");
    }
  }

}
