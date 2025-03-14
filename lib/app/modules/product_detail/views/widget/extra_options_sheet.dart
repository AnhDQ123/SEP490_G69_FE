import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/extra_option.dart';
import '../../controllers/product_detail_controller.dart';

class ExtraOptionsSheet extends StatelessWidget {
  const ExtraOptionsSheet({Key? key}) : super(key: key);

  // Widget hiển thị header dựa trên option được chọn
  Widget _buildHeader(ProductDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Obx(() {
        // Tìm option đầu tiên được chọn, nếu có
        ExtraOption? selectedOption;
        try {
          selectedOption =
              controller.extraOptions.firstWhere((o) => o.selected);
        } catch (e) {
          selectedOption = null;
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị ảnh của option nếu có, hoặc hiển thị placeholder từ network
            Container(
              width: 50,
              height: 50,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: selectedOption != null && selectedOption.imageUrl != null
                  ? Image.network(
                selectedOption.imageUrl!,
                fit: BoxFit.cover,
              )
                  : Image.network(
                'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            // Hiển thị tên và giá của option được chọn
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedOption?.name ?? 'Chọn option',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedOption != null
                        ? '${(selectedOption.price * selectedOption.quantity).toStringAsFixed(0)}đ / ${selectedOption.quantity} ${selectedOption.unit}'
                        : 'Vui lòng chọn option',
                    style: const TextStyle(
                        fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Nút đóng bottom sheet
            InkWell(
              onTap: () => Navigator.pop(Get.context!),
              child: const Icon(Icons.close, size: 24),
            ),
          ],
        );
      }),
    );
  }

  // Widget hiển thị danh sách option dưới dạng chip
  Widget _buildOptionsChips(ProductDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Obx(() {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.extraOptions.map((option) {
            return ChoiceChip(
              label: Text(option.name),
              selected: option.selected,
              selectedColor: Colors.redAccent,
              onSelected: (isSelected) {
                // Reset tất cả option về unselected và đặt quantity = 1
                for (var opt in controller.extraOptions) {
                  opt.selected = false;
                  opt.quantity = 1;
                }
                option.selected = isSelected;
                if (isSelected) {
                  option.quantity = 1;
                }
                controller.extraOptions.refresh();
              },
            );
          }).toList(),
        );
      }),
    );
  }

  // Widget hiển thị điều khiển số lượng cho option được chọn
  Widget _buildQuantityControl(ProductDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Obx(() {
        ExtraOption? selectedOption;
        try {
          selectedOption =
              controller.extraOptions.firstWhere((o) => o.selected);
        } catch (e) {
          selectedOption = null;
        }
        if (selectedOption == null) {
          return const SizedBox();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Số lượng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (selectedOption!.quantity > 1) {
                      selectedOption.quantity--;
                      controller.extraOptions.refresh();
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text('${selectedOption!.quantity}'),
                IconButton(
                  onPressed: () {
                    selectedOption!.quantity++;
                    controller.extraOptions.refresh();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1) Header hiển thị option đã chọn
        _buildHeader(controller),
        const Divider(height: 1, color: Colors.grey),
        // 2) Hiển thị danh sách option dạng chip
        _buildOptionsChips(controller),
        // 3) Hiển thị điều khiển số lượng cho option được chọn
        _buildQuantityControl(controller),
        // 4) Nút "Thêm vào giỏ hàng" cho option
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
                controller.addToCartWithOptions();
              },
              child: const Text(
                'Thêm vào giỏ hàng',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}