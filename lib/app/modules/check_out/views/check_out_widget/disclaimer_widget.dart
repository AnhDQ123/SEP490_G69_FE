import 'package:flutter/material.dart';

class DisclaimerWidget extends StatelessWidget {
  const DisclaimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: Colors.grey[100],
      child: const Text(
        "Bằng cách nhấp vào “Đặt hàng”, bạn đồng ý với các Điều khoản và Dịch vụ của Fast F&B.",
        style: TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }
}
