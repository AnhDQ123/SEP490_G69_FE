import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/base_view.dart';
import '../../../resources/widget/bottom_nav.dart';
import '../controllers/home_controller.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Trang Chủ",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAllNamed('/home');
        },
        backgroundColor: Color.fromRGBO(212, 163, 115, 1),
        child: Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNav(currentIndex: 0),
    );
  }
}
