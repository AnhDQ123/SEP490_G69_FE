// delivery_method_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';
import '../models/delivery.dart';

class DeliveryMethodService {
  final String baseUrl = ApiBaseUrl.baseUrl;
  final http.Client client;

  // Inject http.Client để dễ mock cho testing
  DeliveryMethodService({http.Client? client})
      : client = client ?? http.Client();

  Future<List<DeliveryDTO>> getDeliveryMethodsByShop(int shopId) async {
    final url = Uri.parse('$baseUrl/api/delivery/order?shopId=$shopId');

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<DeliveryDTO>((item) {
          try {
            return DeliveryDTO.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            throw const FormatException('Invalid delivery method data format');
          }
        }).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Shop not found');
      } else {
        throw Exception('Failed to load delivery methods: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}