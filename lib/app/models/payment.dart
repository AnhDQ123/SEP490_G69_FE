import 'dart:convert';

enum Status { ACTIVE, INACTIVE }

class PaymentModel {
  final int id;
  final String name;
  final String description;
  final Status status;
  final double fee;
  final String createdAt;

  PaymentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.fee,
    required this.createdAt,
  });

  // Convert JSON to PaymentModel
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: Status.values.firstWhere((e) => e.toString() == 'Status.' + json['status']),
      fee: json['fee'].toDouble(),
      createdAt: json['createdAt'],
    );
  }

  // Convert PaymentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.toString().split('.').last,
      'fee': fee,
      'createdAt': createdAt,
    };
  }
}
