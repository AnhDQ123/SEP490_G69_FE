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
  final bool isStackable;
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
    required this.isStackable,
    required this.status,
    required this.shopId,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['voucher_id'] ?? 0,
      code: json['code'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
      minOrderValue: (json['min_order_value'] as num?)?.toDouble() ?? 0.0,
      totalVouchers: json['total_vouchers'] ?? 0,
      usedVouchers: json['used_vouchers'] ?? 0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      maxUsagePerCustomer: json['max_usage_per_customer'] ?? 0,
      isStackable: json['is_stackable'] ?? false,
      status: json['status'] ?? '',
      shopId: json['shop_id'] ?? 0,
    );
  }
}
