import 'dart:convert';
import 'package:http/http.dart' as http;

import '../base/api_base_url.dart';
import '../models/cartDTO.dart';


class CartApiService {
  final String baseUrl = ApiBaseUrl.baseUrl;

  Future<bool> addToCart(CartDTO cartDTO) async {
    final url = Uri.parse("$baseUrl/api/cart/add");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cartDTO.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to add to cart: ${response.statusCode}");
    }
  }
}
