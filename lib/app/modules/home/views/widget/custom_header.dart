import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(212, 163, 115, 1),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Thanh tìm kiếm
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Tìm sản phẩm",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Icon chat
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 20),
          ),
          // Icon thông báo
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }
}
