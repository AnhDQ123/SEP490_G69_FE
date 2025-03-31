import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';
import '../models/order.dart';
import '../models/return_order.dart';

class OrderService {
  final String baseUrl = ApiBaseUrl.baseUrl + '/api/order';
  /// 🔁 Lấy đơn hàng theo ID duy nhất
  Future<Order?> fetchOrderById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/checkout?id=$id');
      final response = await http.get(url);

      print("🔥 [GET] $url");
      print("🔥 STATUS: ${response.statusCode}");
      print("🔥 BODY: ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonMap = json.decode(response.body);
        return Order.fromJson(jsonMap);
      } else {
        print("⚠️ Không tìm thấy đơn hàng.");
        return null;
      }
    } catch (e) {
      print("❌ Lỗi fetchOrderById: $e");
      return null;
    }
  }

  /// 🔁 Lấy danh sách đơn hàng theo người dùng + trạng thái (có phân trang)
  Future<List<Order>> fetchOrdersByOwnerAndStatus({
    required int id,
    required String status,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/status?id=$id&status=$status&page=$page&size=$size');
      final response = await http.get(url);

      print("🔥 [GET] $url");
      print("🔥 STATUS: ${response.statusCode}");
      print("🔥 BODY: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final List<dynamic> content = jsonMap['content'] ?? [];
        return content.map((e) => Order.fromJson(e)).toList();
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Lỗi fetchOrdersByOwnerAndStatus: $e");
      return [];
    }
  }

  /// 🏪 Lấy danh sách đơn theo shop + trạng thái (có phân trang)
  Future<List<Order>> fetchOrdersByShopAndStatus({
    required int id,
    required String status,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/shop/status?id=$id&status=$status&page=$page&size=$size');
      final response = await http.get(url);

      print("🏪 [GET] $url");
      print("🔥 STATUS: ${response.statusCode}");
      print("🔥 BODY: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final List<dynamic> content = jsonMap['content'] ?? [];
        return content.map((e) => Order.fromJson(e)).toList();
      } else {
        throw Exception("Lỗi gọi API shop/status");
      }
    } catch (e) {
      print("❌ Lỗi fetchOrdersByShopAndStatus: $e");
      return [];
    }
  }

  /// 🛒 Tạo đơn hàng mới
  Future<List<Order>> createOrder(Order order) async {
    try {
      final url = Uri.parse('$baseUrl/add');
      final body = jsonEncode(order.toJson());

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print("🔥 [POST] $url");
      print("🔥 STATUS: ${response.statusCode}");
      print("🔥 BODY: ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(response.body);
        print("📜 Response from server: $jsonList");

        if (jsonList.isNotEmpty) {
          var responseBody = jsonList[0];
          int? orderId = responseBody['orderId']; // Chắc chắn rằng orderId không phải là null

          if (orderId == null) {
            throw Exception('Invalid orderId returned from server');
          }

          // Tạo Order và trả lại
          return [Order.fromJson(responseBody)];
        } else {
          throw Exception('Order creation failed - empty response');
        }
      } else {
        throw Exception('Unable to create order');
      }

    } catch (e) {
      print("❌ Error in createOrder: $e");
      rethrow;
    }
  }




  /// 🛑 Hủy đơn hàng
  Future<void> cancelOrder(int id) async {
    try {
      final url = Uri.parse('$baseUrl/cancel?id=$id');
      final response = await http.post(url);

      print("🛑 [POST] $url");
      if (response.statusCode != 200) {
        throw Exception('Không thể hủy đơn hàng');
      }
    } catch (e) {
      print("❌ Lỗi cancelOrder: $e");
      rethrow;
    }
  }

  /// ✅ Shop chấp nhận đơn hàng
  Future<void> acceptOrder(int id) async {
    try {
      final url = Uri.parse('$baseUrl/accept?id=$id');
      final response = await http.post(url);

      print("✅ [POST] $url");
      if (response.statusCode != 200) {
        throw Exception('Không thể chấp nhận đơn hàng');
      }
    } catch (e) {
      print("❌ Lỗi acceptOrder: $e");
      rethrow;
    }
  }

  /// ❌ Shop từ chối đơn hàng
  Future<void> rejectOrder(int id) async {
    try {
      final url = Uri.parse('$baseUrl/reject?id=$id');
      final response = await http.post(url);

      print("⛔ [POST] $url");
      if (response.statusCode != 200) {
        throw Exception('Không thể từ chối đơn hàng');
      }
    } catch (e) {
      print("❌ Lỗi rejectOrder: $e");
      rethrow;
    }
  }

  /// 🔄 Đổi trạng thái đơn hàng và gửi file ảnh
  Future<void> changeOrderStatus({
    required int id,
    required String status,
    required int userId,
    required File avatarFile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/changeStatus');

      final request = http.MultipartRequest('POST', uri)
        ..fields['id'] = id.toString()
        ..fields['status'] = status
        ..fields['userId'] = userId.toString()
        ..files.add(await http.MultipartFile.fromPath('avatar', avatarFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📦 [POST] $uri");
      print("🔥 STATUS: ${response.statusCode}");
      print("🔥 BODY: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Lỗi khi đổi trạng thái đơn hàng");
      }
    } catch (e) {
      print("❌ Lỗi changeOrderStatus: $e");
      rethrow;
    }
  }

  /// 🔄 Trả hàng (return order)
  Future<void> returnOrder({
    required int orderId,
    required int userId,
    required String reason,
    required File avatarFile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/returnOrder');

      final request = http.MultipartRequest('POST', uri)
        ..fields['id'] = orderId.toString()
        ..fields['userId'] = userId.toString()
        ..fields['reason'] = reason
        ..files.add(await http.MultipartFile.fromPath('avatar', avatarFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📦 [POST] $uri");
      print("🔥 STATUS: ${response.statusCode}");
      print("🔥 BODY: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("❌ Không thể trả hàng: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Lỗi returnOrder: $e");
      rethrow;
    }
  }

  Future<ReturnOrder?> fetchReturnDetail(int orderId) async {
    final url = Uri.parse('$baseUrl/viewReturn?id=$orderId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ReturnOrder.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  /// ✅ Chấp nhận trả hàng
  Future<void> acceptReturn(int orderId) async {
    try {
      final url = Uri.parse('$baseUrl/acceptReturn?id=$orderId');
      final response = await http.post(url);

      print("✅ [POST] $url");
      print("🔥 STATUS: ${response.statusCode}");

      if (response.statusCode != 200) {
        throw Exception("❌ Không thể chấp nhận trả hàng: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Lỗi acceptReturn: $e");
      rethrow;
    }
  }

  /// ❌ Từ chối trả hàng
  Future<void> rejectReturn(int orderId) async {
    try {
      final url = Uri.parse('$baseUrl/rejectReturn?id=$orderId');
      final response = await http.post(url);

      print("⛔ [POST] $url");
      print("🔥 STATUS: ${response.statusCode}");

      if (response.statusCode != 200) {
        throw Exception("❌ Không thể từ chối trả hàng: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Lỗi rejectReturn: $e");
      rethrow;
    }
  }
}

