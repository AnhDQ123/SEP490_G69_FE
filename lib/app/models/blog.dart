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
  final DateTime? updatedAt;
  final Writer? writer;
  final List<String> imageUrls;
  int commentCount;
  final int likeCount;

  Blog({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.writer,
    required this.imageUrls,
    required this.commentCount,
    required this.likeCount,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      writer: json['writer'] != null ? Writer.fromJson(json['writer']) : null,
      imageUrls: List<String>.from(json['imageUrls']),
      commentCount: json['commentCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
    );
  }
}