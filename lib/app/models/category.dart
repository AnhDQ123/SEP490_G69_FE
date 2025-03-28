class Category {
  final int id;
  final String name;
  final String image;
  final String description;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.description = '',
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
      return Category(
        id: json['id'] ?? 0, // Nếu id bị null, gán giá trị mặc định là 0
        name: json['name'] ?? 'No Name', // Nếu name bị null, gán "No Name"
        description: json['description'] ?? '', // Nếu description bị null, gán chuỗi rỗng
        image: json['image'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSDvRIHDPhNygFHzCXVLlh_ujsoJNBSFz1OA&s',
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      );
  }
}
