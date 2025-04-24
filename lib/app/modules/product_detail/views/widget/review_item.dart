import 'package:flutter/material.dart';
import 'package:ffb_fe_flutter/app/models/feedback.dart' as model;

class ReviewItem extends StatelessWidget {
  final model.Feedback feedback;
  final String fallbackContent;
  const ReviewItem({Key? key, required this.feedback, required this.fallbackContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: feedback.userAvatar != null
                    ? NetworkImage(feedback.userAvatar!)
                    : null,
                child: feedback.userAvatar == null
                    ? const Icon(Icons.person, size: 24, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          if (feedback.rate >= index + 1) {
                            return const Icon(Icons.star, color: Colors.amber, size: 14);
                          } else if (feedback.rate > index) {
                            return const Icon(Icons.star_half, color: Colors.amber, size: 14);
                          } else {
                            return const Icon(Icons.star_border, color: Colors.amber, size: 14);
                          }
                        }),
                        const SizedBox(width: 8),
                        Text(
                          feedback.createdAt.toString().substring(0, 10),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            feedback.content ?? fallbackContent,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          // Trong phần hiển thị ảnh, thay đổi thành:
          if (feedback.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: feedback.images.length,
                  itemBuilder: (context, index) {
                    // Xử lý cả trường hợp image là String hoặc Map
                    final image = feedback.images[index];
                    final imageUrl = image is String
                        ? image
                        : (image is Map ? image['url']?.toString() : null);

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: imageUrl != null
                          ? Image.network(
                        imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                      )
                          : const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}