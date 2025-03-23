import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // 🔹 Background mở rộng lên thanh Quick Settings
        Container(
          height: kToolbarHeight + statusBarHeight,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(212, 163, 115, 1), // Màu nền
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),

        // 🔹 Nội dung chính không bị che
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                // 🔹 Logo
                Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 🔹 Thanh tìm kiếm
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Tìm kiếm sản phẩm...",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
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

                // 🔹 Icon Chat
                _buildIconButton(Icons.chat_bubble_outline, () {
                  // TODO: Thêm chức năng chat
                }),

                // 🔹 Icon Thông báo
                _buildIconButton(Icons.notifications_none, () {
                  // TODO: Thêm chức năng thông báo
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Widget riêng để tạo nút icon đẹp hơn
  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2), // Nền nhẹ hơn cho icon
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
