// delivery_dto.dart
class DeliveryDTO {
  final int id;
  final String name;
  final String description;
  final String status;
  final double fee;
  final DateTime createdAt; // Thay bằng DateTime

  DeliveryDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.fee,
    required this.createdAt,
  });

  factory DeliveryDTO.fromJson(Map<String, dynamic> json) {
    return DeliveryDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String), // Parse thành DateTime
    );
  }
}