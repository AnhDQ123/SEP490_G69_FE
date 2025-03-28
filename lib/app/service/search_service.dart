import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  static const String apiUrl = 'http://192.168.129.9:5001/predict';

  // Gửi yêu cầu tìm kiếm đến API
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      // Gửi yêu cầu POST với dữ liệu query
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        // Phân tích dữ liệu JSON trả về từ API
        final data = json.decode(response.body);
        List<dynamic> results = data['results'];

        // Chuyển đổi kết quả thành dạng dễ sử dụng
        return results.map((result) {
          return {
            'name': result['name'],
            'similarity_score': result['similarity_score']
          };
        }).toList();
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
