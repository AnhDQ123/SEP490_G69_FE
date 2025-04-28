import 'package:flutter/material.dart';
import '../../../../models/user_profile.dart';  // Đảm bảo bạn import đúng model UserProfile

class AddressSectionWidget extends StatelessWidget {
  final UserProfile userProfile;  // Nhận đối tượng UserProfile
  final Function? onAddressSelected;  // Callback khi chọn địa chỉ mới

  const AddressSectionWidget({Key? key, required this.userProfile,this.onAddressSelected,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, size: 16, color: Colors.black54),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Địa chỉ giao hàng",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userProfile.address.isNotEmpty ? userProfile.address : 'Địa chỉ chưa được cập nhật',  // Hiển thị địa chỉ từ UserProfile
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
