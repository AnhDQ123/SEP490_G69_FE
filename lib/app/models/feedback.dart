import 'image_dto.dart';

class Feedback {
  final int id;
  final String? content;
  final double rate;
  final List<dynamic> images; // Thay đổi từ String? sang List<dynamic>
  final String status;
  final String userName;
  final String? userAvatar;
  final DateTime createdAt;

  Feedback({
    required this.id,
    this.content,
    required this.rate,
    required this.images, // Đổi tên từ image sang images cho rõ nghĩa
    required this.status,
    required this.userName,
    this.userAvatar,
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'] ?? 0,
      content: json['content'],
      rate: (json['rate'] ?? 0.0).toDouble(),
      images: json['image'] ?? [], // Giữ nguyên tên field từ API
      status: json['status'] ?? 'ACTIVE',
      userName: json['writer']?['name'] ?? 'Anonymous',
      userAvatar: json['writer']?['avatar'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
    );
  }

  // Thêm phương thức toJson nếu cần gửi dữ liệu lên server
  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'content': content,
      'images': images?.map((img) => img is String ? img : img.url).toList() ?? [],
    };
  }
}