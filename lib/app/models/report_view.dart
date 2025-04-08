import 'dart:convert';
import 'image_dto.dart';  // Import model ImageDTO

class ReportViewDTO {
  final int id;
  final String? reportName;
  final String reportType;
  final int reporterId;
  final int reportedUserId;
  final int reportItemId;
  final String? reason;
  final String status;
  final DateTime createdAt;
  final List<ImageDTO> image;

  ReportViewDTO({
    required this.id,
    this.reportName,
    required this.reportType,
    required this.reporterId,
    required this.reportedUserId,
    required this.reportItemId,
    this.reason,
    required this.status,
    required this.createdAt,
    required this.image,
  });

  // Phương thức từ JSON
  factory ReportViewDTO.fromJson(Map<String, dynamic> json) {
    return ReportViewDTO(
      id: json['id'],
      reportName: json['reportName'],
      reportType: json['reportType'],
      reporterId: json['reporterId'],
      reportedUserId: json['reportedUserId'],
      reportItemId: json['reportItemId'],
      reason: json['reason'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),  // Chuyển đổi chuỗi ngày tháng thành DateTime
      image: (json['image'] as List).map((i) => ImageDTO.fromJson(i)).toList(),
    );
  }

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportName': reportName,
      'reportType': reportType,
      'reporterId': reporterId,
      'reportedUserId': reportedUserId,
      'reportItemId': reportItemId,
      'reason': reason,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'image': image.map((e) => e.toJson()).toList(),  // Chuyển danh sách ảnh thành JSON
    };
  }
}
