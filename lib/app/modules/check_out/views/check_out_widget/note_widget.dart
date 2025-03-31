import 'package:flutter/material.dart';
import '../../../../models/order.dart';

class NoteWidget extends StatefulWidget {
  final Order order; // Added parameter
  const NoteWidget({Key? key, required this.order}) : super(key: key);

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.edit_note_outlined, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Ghi chú cho người giao hàng",
              hintStyle: const TextStyle(fontSize: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }
}
