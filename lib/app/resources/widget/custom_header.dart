import 'package:flutter/material.dart';
import '../../modules/search_screen/views/search_screen_view.dart'; // Import màn hình tìm kiếm

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
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 🔹 Thanh tìm kiếm
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Khi người dùng nhấn vào thanh tìm kiếm, chuyển sang màn hình tìm kiếm
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreenView()),
                      );
                    },
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
                        children: const [
                          Icon(Icons.search, color: Colors.grey, size: 20),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Tìm kiếm sản phẩm...",
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Thêm các nút khác nếu cần
              ],
            ),
          ),
        ),
      ],
    );
  }
}
