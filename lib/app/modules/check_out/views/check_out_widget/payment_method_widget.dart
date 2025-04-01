import 'package:flutter/material.dart';
import '../../../../models/order.dart';

class PaymentMethodWidget extends StatefulWidget {
  final Order order; // Sử dụng model Order
  const PaymentMethodWidget({Key? key, required this.order}) : super(key: key);

  @override
  _PaymentMethodWidgetState createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  String selectedMethod = "Tiền mặt";
  String? selectedBank;
  final TextEditingController _accountController = TextEditingController();

  // Danh sách ngân hàng mẫu
  final List<String> banks = [
    "Vietcombank",
    "Techcombank",
    "VietinBank",
    "BIDV",
  ];

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Phương thức thanh toán",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Tiền mặt
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedMethod = "Tiền mặt";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedMethod == "Tiền mặt" ? Colors.blue : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.money, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text("Tiền mặt", style: TextStyle(fontSize: 10)),
                      if (selectedMethod == "Tiền mặt") ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check, size: 16, color: Colors.blue),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Ngân hàng
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedMethod = "Ngân hàng";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedMethod == "Ngân hàng" ? Colors.blue : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_balance, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text("Ngân hàng", style: TextStyle(fontSize: 10)),
                      if (selectedMethod == "Ngân hàng") ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check, size: 16, color: Colors.blue),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Nếu chọn ngân hàng, hiển thị thêm dropdown và textfield
        if (selectedMethod == "Ngân hàng")
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Chọn ngân hàng:", style: TextStyle(fontSize: 10)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Chọn ngân hàng", style: TextStyle(fontSize: 10)),
                    value: selectedBank,
                    items: banks.map((bank) {
                      return DropdownMenuItem<String>(
                        value: bank,
                        child: Text(bank, style: const TextStyle(fontSize: 10)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBank = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text("Số tài khoản:", style: TextStyle(fontSize: 10)),
              const SizedBox(height: 4),
              TextField(
                controller: _accountController,
                style: const TextStyle(fontSize: 10),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Nhập số tài khoản",
                  hintStyle: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
