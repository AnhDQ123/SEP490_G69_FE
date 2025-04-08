import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/extra_option.dart';
import '../../../../resources/assets_manager.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../controllers/product_detail_controller.dart';

class ExtraOptionsSheet extends StatelessWidget {
  const ExtraOptionsSheet({Key? key}) : super(key: key);

  Widget _buildHeader(ProductDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Obx(() {
        ExtraOption? selectedOption = controller.extraOptions.firstWhereOrNull((o) => o.selected);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: selectedOption?.imageUrl != null
                  ? Image.asset(selectedOption!.imageUrl!, fit: BoxFit.cover)
                  : Image.asset(ImageAssets.defaultFood, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedOption?.name ?? 'Chọn option',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedOption != null
                        ? '${(selectedOption.price * selectedOption.quantity).toStringAsFixed(0)}đ / ${selectedOption.quantity} ${selectedOption.unit}'
                        : 'Vui lòng chọn option',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(Get.context!),
              child: const Icon(Icons.close, size: 22, color: Colors.black54),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildOptionsChips(ProductDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Obx(() {
        return Wrap(
          spacing: 8,
          runSpacing: 6,
          children: controller.extraOptions.map((option) {
            final isSelected = option.selected;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: ChoiceChip(
                label: Text(
                  option.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color.fromRGBO(212, 163, 115, 1),
                backgroundColor: Colors.grey[200],
                labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                onSelected: (isSelected) {
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
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildQuantityControl(ProductDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Obx(() {
        ExtraOption? selectedOption = controller.extraOptions.firstWhereOrNull((o) => o.selected);
        if (selectedOption == null) {
          return const SizedBox();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Số lượng',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (selectedOption.quantity > 1) {
                      selectedOption.quantity--;
                      controller.extraOptions.refresh();
                    }
                  },
                  icon: const Icon(Icons.remove, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  child: Text(
                    '${selectedOption.quantity}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    selectedOption.quantity++;
                    controller.extraOptions.refresh();
                  },
                  icon: const Icon(Icons.add, size: 20),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(controller),
          const Divider(height: 1, color: Colors.grey),
          _buildOptionsChips(controller),
          _buildQuantityControl(controller),
          const SizedBox(height: 8),
          // Nút "Thêm vào giỏ hàng"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(212, 163, 115, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  // Kiểm tra nếu có size nhưng chưa chọn
                  if (controller.hasSelectedSize && controller.selectedSizeIndex.value < 0) {
                    Get.snackbar("Thông báo", "Vui lòng chọn size trước khi thêm vào giỏ hàng");
                    return;
                  }

                  Navigator.pop(context);
                  controller.isAddingToCart.value = true;

                  try {
                    await controller.addToCartWithOptions();

                    if (Get.isRegistered<CartController>()) {
                      await Get.find<CartController>().fetchCart();
                    }

                    Get.snackbar("Thành công", "Đã thêm vào giỏ hàng");
                  } catch (e) {
                    Get.snackbar("Lỗi", "Có lỗi xảy ra: $e");
                  } finally {
                    controller.isAddingToCart.value = false;
                  }
                },



                  icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 18),
                label: const Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

