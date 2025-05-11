class Config {
  final int id;
  final String key;
  final String value;

  Config({
    required this.id,
    required this.key,
    required this.value,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      id: json['id'],
      key: json['key'],
      value: json['value'],
    );
  }
}
