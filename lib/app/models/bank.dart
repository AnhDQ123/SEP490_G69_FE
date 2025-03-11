class Bank {
  final String code;
  final String shortName;
  final String bin;

  Bank({required this.code, required this.shortName, required this.bin});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      code: json['code'] ?? '',  // Tránh null
      shortName: json['shortName'] ?? 'Không rõ', // Nếu null, gán tên mặc định
      bin: json['bin'] ?? '',   // Tránh null
    );
  }
}
