import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CancelReasonSheet extends StatefulWidget {
  @override
  _CancelReasonSheetState createState() => _CancelReasonSheetState();
}

class _CancelReasonSheetState extends State<CancelReasonSheet> {
  String? selectedReason;
  final TextEditingController customReasonController = TextEditingController();

  final List<String> reasons = [
    "Đặt nhầm sản phẩm",
    "Thay đổi địa chỉ giao hàng",
    "Không còn nhu cầu",
    "Khác (vui lòng nhập lý do)"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Chọn lý do huỷ đơn", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...reasons.map((reason) => RadioListTile<String>(
            title: Text(reason),
            value: reason,
            groupValue: selectedReason,
            onChanged: (value) {
              setState(() {
                selectedReason = value;
              });
            },
          )),
          if (selectedReason == "Khác (vui lòng nhập lý do)")
            TextField(
              controller: customReasonController,
              decoration: const InputDecoration(labelText: "Nhập lý do huỷ đơn"),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final reason = selectedReason == "Khác (vui lòng nhập lý do)"
                  ? customReasonController.text.trim()
                  : selectedReason;
              Navigator.of(context).pop(reason);
            },
            child: const Text("Xác nhận huỷ"),
          ),
        ],
      ),
    );
  }
}
