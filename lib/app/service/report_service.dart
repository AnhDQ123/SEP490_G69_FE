import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../base/api_base_url.dart';
import '../models/report_create.dart';
import '../models/report_view.dart';

class ReportService {
  final String apiUrl = '${ApiBaseUrl.baseUrl}/api/report';

  Future<ReportViewDTO?> getReportById(int id) async {
    try {
      var uri = Uri.parse('$apiUrl/$id');
      var response = await http.get(uri).timeout(Duration(seconds: 10)); // Timeout 10 giây

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return ReportViewDTO.fromJson(responseData);
      } else {
        print('Failed to load report. Status: ${response.statusCode}, Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  Future<bool> createReport(ReportCreateDTO reportCreateDTO, List<File> images) async {
    try {
      var uri = Uri.parse('$apiUrl/add');
      var request = http.MultipartRequest('POST', uri);

      // Thêm các trường văn bản
      request.fields['userId'] = reportCreateDTO.userId.toString();
      request.fields['relatedId'] = reportCreateDTO.relatedId.toString();
      request.fields['typeId'] = reportCreateDTO.typeId.toString();
      request.fields['reason'] = reportCreateDTO.reason;

      // Thêm các tệp (hình ảnh)
      for (var image in images) {
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();
        var multipartFile = http.MultipartFile('option', stream, length, filename: image.uri.pathSegments.last);
        request.files.add(multipartFile);
      }

      // Gửi yêu cầu
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Report created successfully');
        return true;
      } else {
        print('Failed to create report. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> addEvidence(int reportId, List<File> images) async {
    try {
      var uri = Uri.parse('$apiUrl/add');  // Chỉ định endpoint mà không cần thêm id vào đường dẫn

      var request = http.MultipartRequest('POST', uri);

      // Thêm tham số 'id' vào query parameter
      request.fields['id'] = reportId.toString();  // Truyền 'id' như một query parameter

      // Thêm các tệp ảnh vào báo cáo
      for (var image in images) {
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();
        var multipartFile = http.MultipartFile('option', stream, length, filename: image.uri.pathSegments.last);
        request.files.add(multipartFile);
      }

      // Gửi yêu cầu
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Images added to report successfully');
        return true;
      } else {
        print('Failed to add images to report. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }



  // Lấy tất cả báo cáo của cửa hàng
  Future<Map<String, dynamic>> getAllByShop(int shopId, int page, int size) async {
    try {
      var uri = Uri.parse('$apiUrl/shop/$shopId?page=$page&size=$size');
      var response = await http.get(uri).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['content'] != null) {
          var reportList = (responseData['content'] as List)
              .map((data) => ReportViewDTO.fromJson(data))
              .toList();
          return {
            'reports': reportList,
            'totalPages': responseData['totalPages'],
          };
        }
      }
      return {'reports': [], 'totalPages': 1};
    } catch (e) {
      print('Error occurred: $e');
      return {'reports': [], 'totalPages': 1};
    }
  }



}
