import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // giảm padding dọc từ 16 xuống 8
      child: Row(
        children: [
          const Expanded(
            child: Divider(thickness: 0.5), // giảm độ dày Divider
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8), // giảm padding ngang
            child: Text(
              "Có thể bạn cũng thích",
              style: TextStyle(
                fontSize: 12, // giảm font size từ 14 xuống 12
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          const Expanded(
            child: Divider(thickness: 0.5),
          ),
        ],
      ),
    );
  }
}
