class Discount {
  final int id;
  final double amount;  // Giảm giá (phần trăm hoặc cố định)
  final String startDate;
  final String endDate;
  final String status;  // Trạng thái: ACTIVE, INACTIVE

  Discount({
    required this.id,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }
}
