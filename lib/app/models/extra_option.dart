class ExtraOption {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;   // có thể null
  final String unit;        // đơn vị
  bool selected;            // cho checkbox/chip
  int quantity;             // nếu muốn có số lượng riêng

  ExtraOption({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.unit = '',
    this.selected = false,
    this.quantity = 1,
  });
}
