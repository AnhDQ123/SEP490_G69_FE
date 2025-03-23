import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';


class TabSwitchWidget extends StatelessWidget {
  final bool isLogin;

  const TabSwitchWidget({Key? key, required this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.LOGIN),
            child: Column(
              children: [
                Text(
                  "Đăng nhập",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isLogin ? Colors.black : Colors.grey,
                  ),
                ),
                if (isLogin)
                  Container(
                    width: 40,
                    height: 2,
                    color: Colors.brown,
                    margin: EdgeInsets.only(top: 5),
                  ),
              ],
            ),
          ),
          SizedBox(width: 30),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.REGISTER),
            child: Column(
              children: [
                Text(
                  "Đăng ký",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: !isLogin ? Colors.black : Colors.grey,
                  ),
                ),
                if (!isLogin)
                  Container(
                    width: 50,
                    height: 2,
                    color: Colors.brown,
                    margin: EdgeInsets.only(top: 5),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
