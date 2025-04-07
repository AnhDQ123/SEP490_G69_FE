class Writer {
  final int id;
  final String name;
  final String? avatarUrl;

  Writer({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

class Blog {
  final int id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Writer writer;
  final List<String> imageUrls;
  final int commentCount;

  Blog({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.writer,
    required this.imageUrls,
    required this.commentCount,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      writer: Writer.fromJson(json['writer']),
      imageUrls: List<String>.from(json['imageUrls']),
      commentCount: json['commentCount'],
    );
  }
}
