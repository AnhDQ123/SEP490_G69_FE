class ReportCreateDTO {
  final int userId;
  final int relatedId;
  final int typeId;
  final String reason;
  final List<String> options;

  ReportCreateDTO({
    required this.userId,
    required this.relatedId,
    required this.typeId,
    required this.reason,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'relatedId': relatedId,
      'typeId': typeId,
      'reason': reason,
      'option': options,
    };
  }
}
