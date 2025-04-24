import 'package:http/http.dart' as http;
import 'dart:convert';
import '../base/api_base_url.dart';
import '../models/voucher.dart';  // Import model Voucher

class VoucherService {
  // API base URL
  final String baseUrl = ApiBaseUrl.baseUrl;

  // Fetch danh sách voucher của cửa hàng
  Future<List<Voucher>?> fetchVouchersByShopId(int shopId) async {
    try {
      final url = Uri.parse('$baseUrl/api/vouchers/shop/$shopId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Voucher.fromJson(json)).toList();
      } else {
        throw Exception('Không thể lấy voucher từ server');
      }
    } catch (e) {
      throw Exception('Lỗi khi gọi API: $e');
    }
  }

  // Áp dụng voucher cho đơn hàng
  Future<double?> applyVoucher(String code, double orderTotal, int userId) async {
    try {
      final url = Uri.parse('$baseUrl/api/vouchers/apply').replace(queryParameters: {
        'code': code,
        'orderTotal': orderTotal.toString(),
        'userId': userId.toString(),
      });

      final response = await http.post(url); // KHÔNG gửi body nữa


      if (response.statusCode == 200) {
        final discountAmount = json.decode(response.body);
        return discountAmount.toDouble();
      } else {
        throw Exception('Không thể áp dụng voucher');
      }
    } catch (e) {
      throw Exception('Lỗi khi áp dụng voucher: $e');
    }
  }
}
