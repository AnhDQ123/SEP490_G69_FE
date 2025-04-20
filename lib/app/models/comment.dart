import 'blog.dart';

class Comment {
  final int id;
  final String content;
  final Writer? writer;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? parentId;
  final String? parentWriterName;
  final int likeCount;
  final int replyCount;
  final bool hasMoreReplies;
  final List<Comment> replies; // Có thể truyền từ nơi khác nếu cần

  Comment({
    required this.id,
    required this.content,
    required this.writer,
    this.createdAt,
    this.updatedAt,
    this.parentId,
    this.parentWriterName,
    required this.likeCount,
    required this.replyCount,
    required this.hasMoreReplies,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      writer: json['writer'] != null ? Writer.fromJson(json['writer']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      parentId: json['parentId'],
      parentWriterName: json['parentWriterName'],
      likeCount: json['likeCount'] ?? 0,
      replyCount: json['replyCount'] ?? 0,
      hasMoreReplies: json['hasMoreReplies'] ?? false,
      replies: [], // 👈 nếu bạn có field replies trong constructor
    );
  }

}