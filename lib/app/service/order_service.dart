import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'http://10.33.48.42:8080/api/order';

  Future<List<Order>> fetchOrders(List<int> ids) async {
    try {
      final url = Uri.parse('$baseUrl/checkout?ids=${ids.join(',')}');
      final response = await http.get(url);

      print("🔥 API URL: $url");
      print("🔥 HTTP STATUS: ${response.statusCode}");
      print("🔥 API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("⚠️ API trả về dữ liệu rỗng!");
          return [];
        }

        final List<dynamic> jsonList = json.decode(response.body);

        if (jsonList.isEmpty) {
          print("⚠️ Danh sách đơn hàng rỗng.");
          return [];
        }

        return jsonList.map((json) => Order.fromJson(json)).toList();
      } else {
        print("❌ Lỗi API: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Lỗi khi fetchOrders: $e");
      return [];
    }
  }


}
