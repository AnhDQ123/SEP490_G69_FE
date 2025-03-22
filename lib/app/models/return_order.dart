import 'order.dart';
import 'image_dto.dart'; // import nếu nằm file riêng

class ReturnOrder {
  final Order order;
  final List<ImageDTO> images;

  ReturnOrder({
    required this.order,
    required this.images,
  });

  factory ReturnOrder.fromJson(Map<String, dynamic> json) {
    return ReturnOrder(
      order: Order.fromJson(json['order']),
      images: (json['image'] as List)
          .map((img) => ImageDTO.fromJson(img))
          .toList(),
    );
  }
}
