import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'http://192.168.1.12:8080/api/order';

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

  // Phương thức mới để fetch đơn hàng theo owner và trạng thái
  Future<List<Order>> fetchOrdersByOwnerAndStatus({required int id, required String status}) async {
    try {
      final url = Uri.parse('$baseUrl/status?id=$id&status=$status');
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
      print("❌ Lỗi khi fetchOrdersByOwnerAndStatus: $e");
      return [];
    }
  }

  Future<void> cancelOrder(int id) async {
    try {
      final url = Uri.parse('$baseUrl/cancel?id=$id');
      final response = await http.post(url);

      print("🔥 API URL: $url");
      print("🔥 HTTP STATUS: ${response.statusCode}");
      print("🔥 API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        print("Order cancelled successfully");
      } else {
        print("❌ Lỗi API: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Lỗi khi cancelOrder: $e");
      rethrow;
    }
  }

  Future<List<Order>> createOrder(Order order) async {
    try {
      final url = Uri.parse('$baseUrl/add');
      // Chuyển đổi Order thành JSON
      final body = jsonEncode(order.toJson());

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

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
      print("❌ Lỗi khi createOrder: $e");
      return [];
    }
  }


}
