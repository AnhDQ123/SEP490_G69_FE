import 'package:flutter/material.dart';

class SizeOptionWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SizeOptionWidget({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16), // Hiệu ứng nhấn bo tròn góc
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Hiệu ứng chuyển màu mượt hơn
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(212, 163, 115, 1) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color.fromRGBO(212, 163, 115, 1) : Colors.grey.shade400,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.shade200.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
