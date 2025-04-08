class ShipPaymentDTO {
  final int shipperId;
  final String shipperName;
  final double amount;

  ShipPaymentDTO({
    required this.shipperId,
    required this.shipperName,
    required this.amount,
  });

  factory ShipPaymentDTO.fromJson(Map<String, dynamic> json) {
    return ShipPaymentDTO(
      shipperId: json['shipperId'],
      shipperName: json['shipperName'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

