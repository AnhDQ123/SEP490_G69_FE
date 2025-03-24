import 'package:intl/intl.dart';

enum VoucherStatus { PENDING, ACTIVE, INACTIVE ,REJECTED, DELETED }

VoucherStatus parseVoucherStatus(String status) {
  switch (status.toUpperCase()) {
    case 'PENDING':
      return VoucherStatus.PENDING;
    case 'ACTIVE':
      return VoucherStatus.ACTIVE;
    case 'INACTIVE':
      return VoucherStatus.INACTIVE;
    case 'REJECTED':
      return VoucherStatus.REJECTED;
    default:
      return VoucherStatus.DELETED;
  }
}

String voucherStatusToString(VoucherStatus status) {
  return status.toString().split('.').last;
}

class VoucherModel {
  final int id;
  final String code;
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final VoucherStatus status;
  final int? shopId; // optional
  final int? usedCount;

  VoucherModel({
    required this.id,
    required this.code,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.shopId,
    this.usedCount,
    this.usageLimit,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'],
      code: json['code'],
      discountPercentage: (json['discount_percentage'] as num).toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: parseVoucherStatus(json['status']),
      shopId: json['shop']?['id'],
      usedCount: json['used_count'] ?? 0,
    );
  }


  String get remainingDays {
    final now = DateTime.now();
    final diff = endDate.difference(now).inDays;
    if (diff < 0) return 'Đã hết hạn';
    return '$diff ngày';
  }

  final int? usageLimit; // thêm vào model

  String get usageProgress {
    if (usedCount != null && usageLimit != null) {
      return '$usedCount/$usageLimit';
    }
    return '${usedCount ?? 0} lượt';
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'discount_percentage': discountPercentage,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'status': voucherStatusToString(status),
    'shop_id': shopId,
  };

  String get formattedDateRange {
    final formatter = DateFormat('dd/MM/yyyy');
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }
}
