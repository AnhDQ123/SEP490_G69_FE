import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  final dynamic review;
  const ReviewItem({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem review có avatar hay không
    final String avatarUrl = review['avatar'] ?? '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        avatarUrl.isNotEmpty
            ? CircleAvatar(
          backgroundImage: NetworkImage(avatarUrl),
        )
            : const CircleAvatar(
          child: Icon(Icons.person),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review['user'] ?? 'Anonymous',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    double rating = review['rating'];
                    if (rating >= index + 1) {
                      return const Icon(Icons.star, color: Colors.amber, size: 14);
                    } else if (rating > index && rating < index + 1) {
                      return const Icon(Icons.star_half, color: Colors.amber, size: 14);
                    } else {
                      return const Icon(Icons.star_border, color: Colors.amber, size: 14);
                    }
                  }),
                  const SizedBox(width: 4),
                  Text(review['rating'].toString()),
                ],
              ),
              const SizedBox(height: 4),
              Text(review['comment'] ?? ''),
            ],
          ),
        ),
      ],
    );
  }
}
