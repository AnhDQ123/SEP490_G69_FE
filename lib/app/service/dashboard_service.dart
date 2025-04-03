import 'dart:convert';
import 'package:ffb_fe_flutter/app/base/api_base_url.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  // Hàm lấy danh sách đơn hàng theo tháng
  Future<List<Map<String, dynamic>>> getShopOrdersByMonth(int shopId) async {
    // URL API của bạn
    final url = ApiBaseUrl.baseUrl + '/api/shops/count/order/month?status=DELIVERED&shopId=$shopId';

    try {
      // Gửi yêu cầu GET đến API
      final response = await http.get(Uri.parse(url));

      // Kiểm tra mã trạng thái trả về
      if (response.statusCode == 200) {
        // Nếu API trả về thành công, giải mã JSON
        final List<dynamic> data = json.decode(response.body);

        // Trả về dữ liệu đã được chuyển thành List<Map<String, dynamic>> để dễ sử dụng
        return data.map((e) => {
          'month': e[0],
          'year': e[1],
          'orderCount': e[2],
        }).toList();
      } else {
        // Nếu có lỗi trong quá trình gọi API
        throw Exception('Failed to load orders by month');
      }
    } catch (e) {
      // Xử lý lỗi nếu có sự cố mạng hoặc lỗi bất kỳ
      throw Exception('Error: $e');
    }
  }
}
