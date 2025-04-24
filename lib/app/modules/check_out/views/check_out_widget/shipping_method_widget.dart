import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/delivery.dart';
import '../../controllers/check_out_controller.dart';

class ShippingMethodWidget extends StatelessWidget {
  final CheckOutController controller;

  const ShippingMethodWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  // Hàm mở BottomSheet để chọn phương thức giao hàng
  void _showDeliveryMethodsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Chọn phương thức giao hàng",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.isLoadingDeliveryMethods.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessageDeliveryMethods.isNotEmpty) {
                  return Text(
                    controller.errorMessageDeliveryMethods.value,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (controller.deliveryMethods.isEmpty) {
                  return const Text("Không có phương thức giao hàng nào");
                }

                return Expanded(
                  child: ListView(
                    children: controller.deliveryMethods.map((method) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: RadioListTile<DeliveryDTO>(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (method.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    method.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              Text(
                                "Phí: ${method.fee}đ",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          value: method,
                          groupValue: controller.deliveryMethods.firstWhere(
                                (element) =>
                            element.id == controller.order.value?.shipMethodId,
                            orElse: () => controller.deliveryMethods.first,
                          ),
                          onChanged: (DeliveryDTO? value) {
                            if (value != null) {
                              // Cập nhật phương thức giao hàng đã chọn
                              controller.selectDeliveryMethod(value);

                              // Tính toán lại tổng tiền sau khi thay đổi phương thức giao hàng
                              double currentTotal = controller.order.value?.total ?? 0;
                              double newTotal = currentTotal + value.fee; // Cộng thêm phí vận chuyển

                              // Gọi API cập nhật tổng tiền
                              controller.updateOrderTotal(newTotal);

                              // Đóng bottom sheet sau khi chọn
                              Navigator.pop(context);
                            }
                          },

                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PHƯƠNG THỨC GIAO HÀNG",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showDeliveryMethodsBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                const Icon(Icons.delivery_dining, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    if (controller.deliveryMethods.isNotEmpty) {
                      var selectedMethod = controller.deliveryMethods.firstWhere(
                            (method) => method.id == controller.order.value?.shipMethodId,
                        orElse: () => controller.deliveryMethods.first,
                      );
                      return Text(
                        selectedMethod.name,
                        style: const TextStyle(fontSize: 14),
                      );
                    } else {
                      return const Text(
                        'Chọn phương thức giao hàng',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      );
                    }
                  }),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
