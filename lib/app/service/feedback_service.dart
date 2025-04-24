import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ffb_fe_flutter/app/models/feedback.dart';

import '../base/api_base_url.dart';

class FeedbackService {
  Future<List<Feedback>> getProductFeedbacks(int productId, {int page = 1, int size = 20}) async {
    try {
      final response = await http.get(
          Uri.parse("${ApiBaseUrl.baseUrl}/api/feedback/product/$productId?page=$page&size=$size")
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final feedbacksList = jsonData is List ? jsonData : jsonData['content'] ?? [];

        return feedbacksList.map<Feedback>((item) {
          try {
            // Xử lý trường hợp writer null
            final writer = item['writer'] ?? {};
            return Feedback.fromJson({
              ...item,
              'writer': writer,
            });
          } catch (e) {
            print('Error parsing feedback: $e\nItem: $item');
            return Feedback(
              id: 0,
              rate: 0,
              images: [],
              status: 'ERROR',
              userName: 'Error',
              createdAt: DateTime.now(),
            );
          }
        }).toList();
      } else {
        throw Exception('Failed to load feedbacks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching feedbacks: $e');
      rethrow;
    }
  }

  Future<bool> createFeedback({
    required int userId,
    required int productId,
    required double rate,
    String? content,
    List<String>? imageUrls,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiBaseUrl.baseUrl}/api/feedback/create?userId=$userId&productId=$productId"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'rate': rate,
          'content': content,
          'images': imageUrls ?? [],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create feedback. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating feedback: $e');
      rethrow;
    }
  }


}