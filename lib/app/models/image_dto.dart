class ImageDTO {
  final String url;
  final int relatedId;
  final int ownerId;
  final int id;
  final int typeId;

  ImageDTO({
    required this.url,
    required this.relatedId,
    required this.ownerId,
    required this.id,
    required this.typeId,
  });

  // Phương thức từ JSON
  factory ImageDTO.fromJson(Map<String, dynamic> json) {
    return ImageDTO(
      url: json['url'] ?? '',
      relatedId: json['relatedId'] ?? 0,
      ownerId: json['ownerId'] ?? 0,
      id: json['id'] ?? 0,
      typeId: json['typeId'] ?? 0,
    );
  }

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'relatedId': relatedId,
      'ownerId': ownerId,
      'id': id,
      'typeId': typeId,
    };
  }
}
