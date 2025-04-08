import 'package:flutter/material.dart';

class DisclaimerWidget extends StatefulWidget {
  const DisclaimerWidget({Key? key}) : super(key: key);

  @override
  _DisclaimerWidgetState createState() => _DisclaimerWidgetState();
}

class _DisclaimerWidgetState extends State<DisclaimerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    // Chạy animation một lần (forward) và dừng lại khi hoàn thành.
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: const Text(
          "Bằng cách nhấp vào “Đặt hàng”, bạn đồng ý với các Điều khoản và Dịch vụ của Fast F&B.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: Colors.redAccent,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
