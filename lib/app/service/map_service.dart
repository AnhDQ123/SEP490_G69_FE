// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../base/api_base_url.dart';
// import '../models/coordinate.dart';
//
// class MapService {
//   final String baseUrl;
//
//   MapService({this.baseUrl = ApiBaseUrl.baseUrl});
//
//   Future<CoordinateModel?> getCoordinates(String address) async {
//     final url = Uri.parse('$baseUrl/api/map/geocode?address=$address');
//
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       print("📍 Dữ liệu tọa độ từ backend: $data");  // 👈 thêm dòng này
//       return CoordinateModel.fromJson(data);
//     } else {
//       print("❌ Lỗi API: ${response.body}");
//       return null;
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';
import '../models/coordinate.dart';

class MapService {
  final String baseUrl;

  MapService({this.baseUrl = ApiBaseUrl.baseUrl});

  Future<CoordinateModel?> getCoordinates(String address, {double? lat, double? lng}) async {
    String query = '$baseUrl/api/map/geocode?address=${Uri.encodeComponent(address)}';
    if (lat != null && lng != null) {
      query += '&lat=$lat&lng=$lng';
    }

    final url = Uri.parse(query);
    final response = await http.get(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      print("📍 Dữ liệu tọa độ từ backend: $data");
      return CoordinateModel.fromJson(data);
    } else {
      print("❌ Lỗi API hoặc body trống: ${response.body}");
      return null;
    }
  }
}
