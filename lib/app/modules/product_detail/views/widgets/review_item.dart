import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  // Bạn có thể thay kiểu 'dynamic' bằng model Review của bạn nếu đã định nghĩa
  final dynamic review;
  const ReviewItem({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(review.avatarUrl),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(review.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    ...List.generate(5, (index) {
                      double rating = review.rating;
                      if (rating >= index + 1) {
                        return const Icon(Icons.star, color: Colors.amber, size: 14);
                      } else if (rating > index && rating < index + 1) {
                        return const Icon(Icons.star_half, color: Colors.amber, size: 14);
                      } else {
                        return const Icon(Icons.star_border, color: Colors.amber, size: 14);
                      }
                    }),
                  ],
                ),
                const SizedBox(height: 4),
                Text(review.comment),
                const SizedBox(height: 4),
                Text(review.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
