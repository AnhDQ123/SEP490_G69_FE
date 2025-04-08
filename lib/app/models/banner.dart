class BannerDTO {
  final int bannerId;
  final String url;
  final int shopId;
  final String status;

  BannerDTO({
    required this.bannerId,
    required this.url,
    required this.shopId,
    required this.status,
  });

  factory BannerDTO.fromJson(Map<String, dynamic> json) {
    return BannerDTO(
      bannerId: json['bannerId'],
      url: json['url'],
      shopId: json['shopId'],
      status: json['status'],
    );
  }
}
