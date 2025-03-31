
import 'package:flutter/material.dart';
import '../../../../models/order.dart';

class ExtraToolWidget extends StatefulWidget {
  final Order order; // Added parameter
  const ExtraToolWidget({Key? key, required this.order}) : super(key: key);

  @override
  _ExtraToolWidgetState createState() => _ExtraToolWidgetState();
}

class _ExtraToolWidgetState extends State<ExtraToolWidget> {
  bool needTool = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.restaurant, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        const Text("Thêm dụng cụ ăn uống", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const Spacer(),
        Switch(
          value: needTool,
          onChanged: (val) {
            setState(() {
              needTool = val;
            });
          },
        ),
      ],
    );
  }
}

