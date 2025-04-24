import 'package:http/http.dart' as http;
import 'dart:convert';

import '../base/api_base_url.dart';


class PaymentService {
  final String _baseUrl = ApiBaseUrl.baseUrl;

  // Fetch payments with pagination
  Future<Map<String, dynamic>> getPayments(int page, int size, String sort) async {
    final url = Uri.parse('$_baseUrl/api/payment?page=$page&size=$size&sort=$sort');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body); // Trả về dữ liệu JSON từ response
      } else {
        throw Exception('Failed to load payments');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching payments: $e');
    }
  }
}
