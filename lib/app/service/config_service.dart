import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';
import '../models/config.dart';

class ConfigService {
  final String baseUrl = "${ApiBaseUrl.baseUrl}/api/config";

  Future<List<Config>> fetchReturnReasons() async {
    final url = Uri.parse('$baseUrl/RETURN_REASON?page=0&size=50');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> content = data['content'] ?? [];
      return content.map((e) => Config.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải lý do trả hàng');
    }
  }
}
