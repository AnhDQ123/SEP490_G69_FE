import 'package:flutter/material.dart';
import '../../../../models/check_out.dart';
import 'package:get/get.dart';
import '../../controllers/check_out_controller.dart';

class NoteWidget extends StatelessWidget {
  final CheckoutInfo checkout;
  const NoteWidget({Key? key, required this.checkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckOutController>();
    final textController = TextEditingController(text: checkout.note);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.edit_note_outlined, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: textController,
            onChanged: (value) => controller.updateNote(value),
            decoration: InputDecoration(
              hintText: "Ghi chú cho người giao hàng",
              hintStyle: const TextStyle(fontSize: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(8),
            ),
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}
