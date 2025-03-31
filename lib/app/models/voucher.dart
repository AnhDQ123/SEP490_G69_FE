class Voucher {
  final int id;
  final String code;
  final String discountType; // e.g., PERCENTAGE, AMOUNT
  final double discountValue;
  final double minOrderValue;
  final int totalVouchers;
  final int usedVouchers;
  final String startDate;
  final String endDate;
  final int maxUsagePerCustomer;
  final String status;
  final int shopId;  // shopId cần thiết cho phân biệt voucher của cửa hàng

  Voucher({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.minOrderValue,
    required this.totalVouchers,
    required this.usedVouchers,
    required this.startDate,
    required this.endDate,
    required this.maxUsagePerCustomer,
    required this.status,
    required this.shopId,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['voucher_id'] ?? 0,
      code: json['code'] ?? '',
      discountType: json['discountType'] ?? '',
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      minOrderValue: (json['minOrderValue'] as num?)?.toDouble() ?? 0.0,
      totalVouchers: json['totalVouchers'] ?? 0,
      usedVouchers: json['usedVouchers'] ?? 0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      maxUsagePerCustomer: json['maxUsagePerCustomer'] ?? 1,
      status: json['status'] ?? '',
      shopId: json['shopId'] ?? 0,
    );
  }

}
