import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/shop_register_controller.dart';

class Step2 extends StatelessWidget {
  final ShopRegisterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vui lòng đọc kỹ điều khoản và điều kiện",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          _buildTermsCard(),
          SizedBox(height: 12),
          Obx(() => CheckboxListTile(
                value: controller.isTermsAccepted.value,
                onChanged: (value) {
                  controller.isTermsAccepted(value!);
                },
                title: Text(
                  "Tôi xác nhận rằng đã đọc tất cả các điều khoản và điều kiện nêu trên và đồng ý với Fast F&B để trở thành đối tác bán hàng của Fast F&B",
                  style: TextStyle(fontSize: 14),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              )),
          SizedBox(height: 8),
          Text(
            "• Bằng việc tiếp tục đăng ký, Đối tác đồng ý sẽ chịu toàn bộ trách nhiệm liên quan đến việc đăng bán **SẢN PHẨM BỊ CẤM** trên Fast F&B",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Icon(Icons.picture_as_pdf, size: 40, color: Colors.black),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Điều khoản và điều kiện",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.download, color: Colors.black),
            onPressed: () {
              // TODO: logic tải file PDF điều khoản
            },
          ),
        ],
      ),
    );
  }
}
