class Category {
  final int id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0, // Nếu id bị null, gán giá trị mặc định là 0
      name: json['name'] ?? 'No Name', // Nếu name bị null, gán "No Name"
      image: json['image'] ?? 'https://yourserver.com/default_image.png',
    );
  }
}
