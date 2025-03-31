import 'package:flutter/material.dart';

class OrderTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;

  const OrderTabBar({Key? key, required this.tabs}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(30);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      labelStyle: const TextStyle(fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      labelColor: const Color.fromRGBO(212, 163, 115, 1),
      unselectedLabelColor: Colors.grey,
      indicatorColor: const Color.fromRGBO(212, 163, 115, 1),
      tabs: tabs.map((text) => Tab(text: text)).toList(),
    );
  }
}
