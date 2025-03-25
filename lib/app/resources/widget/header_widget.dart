import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final Color backgroundColor;

  const HeaderWidget({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Center(
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage("assets/images/logo.png"),
            backgroundColor: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
