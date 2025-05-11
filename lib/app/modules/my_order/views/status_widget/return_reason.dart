// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class ReturnReasonSheet extends StatefulWidget {
//   @override
//   _ReturnReasonSheetState createState() => _ReturnReasonSheetState();
// }
//
// class _ReturnReasonSheetState extends State<ReturnReasonSheet> {
//   String? selectedReason;
//   final TextEditingController customReasonController = TextEditingController();
//
//   final List<String> reasons = [
//     "Có vấn đề về chất lượng",
//     "Món ăn không đúng mô tả",
//     "Không đúng kích cỡ món",
//     "Giao không đúng món",
//     "Khác (vui lòng nhập lý do)"
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text("Chọn lý do trả hàng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           ...reasons.map((reason) => RadioListTile<String>(
//             title: Text(reason),
//             value: reason,
//             groupValue: selectedReason,
//             onChanged: (value) {
//               setState(() {
//                 selectedReason = value;
//               });
//             },
//           )),
//           if (selectedReason == "Khác (vui lòng nhập lý do)")
//             TextField(
//               controller: customReasonController,
//               decoration: const InputDecoration(labelText: "Nhập lý do trả hàng"),
//             ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               final reason = selectedReason == "Khác (vui lòng nhập lý do)"
//                   ? customReasonController.text.trim()
//                   : selectedReason;
//               Navigator.of(context).pop(reason);
//             },
//             child: const Text("Xác nhận"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ReturnReasonSheet extends StatefulWidget {
  final List<String> reasons;

  const ReturnReasonSheet({super.key, required this.reasons});

  @override
  _ReturnReasonSheetState createState() => _ReturnReasonSheetState();
}

class _ReturnReasonSheetState extends State<ReturnReasonSheet> {
  String? selectedReason;
  final TextEditingController customReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Chọn lý do trả hàng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...widget.reasons.map((reason) => RadioListTile<String>(
            title: Text(reason),
            value: reason,
            groupValue: selectedReason,
            onChanged: (value) {
              setState(() => selectedReason = value);
            },
          )),
          if (selectedReason == "Khác (vui lòng nhập lý do)")
            TextField(
              controller: customReasonController,
              decoration: const InputDecoration(labelText: "Nhập lý do trả hàng"),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final reason = selectedReason == "Khác (vui lòng nhập lý do)"
                  ? customReasonController.text.trim()
                  : selectedReason;
              Navigator.of(context).pop(reason);
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }
}

