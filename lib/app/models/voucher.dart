class Voucher {
  final String name;
  final double value; // Giá trị giảm

  Voucher({required this.name, required this.value});

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}
