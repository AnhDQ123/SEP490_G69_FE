import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/order.dart';
import '../../../service/shipper_service.dart';
import 'package:url_launcher/url_launcher.dart';


class ShipperOrderListController extends GetxController {
  final RxString selectedStatus = 'SHIP_PENDING'.obs;
  final RxList<Order> orders = <Order>[].obs;

  List<Order> get filteredOrders =>
      orders.where((o) => o.status == selectedStatus.value).toList();

  void setStatus(String status) {
    selectedStatus.value = status;
  }

  Future<void> refreshOrders() async {
    try {
      final updated = await ShipperService().fetchOrdersByShipper(3);
      orders.assignAll(updated);        // Cập nhật danh sách
      orders.refresh();                 // ⚠️ BẮT BUỘC: thông báo Obx rebuild lại
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể làm mới danh sách đơn hàng");
    }
  }


  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    final List<Order> receivedOrders = args['orders'] ?? [];
    final String initialStatus = args['status'] ?? 'SHIP_PENDING';

    orders.assignAll(receivedOrders);
    selectedStatus.value = initialStatus;
  }

  Future<void> handleAcceptOrder(Order order, int userId) async {
    final service = ShipperService();
    final result = await service.acceptShipping(orderId: order.id, userId: userId);

    if (result.success) {
      final index = orders.indexWhere((o) => o.id == order.id);
      orders[index].status = 'SHIPPING'; // ✅ Cập nhật trạng thái
      orders.refresh();                  // ✅ Trigger UI update cho Obx
      Get.snackbar(
        "✅ Thành công",
        "Đơn hàng #${order.id} đã được xác nhận.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar("❌ Lỗi", result.message);
    }
  }

  Future<void> handleConfirmDelivered({
    required Order order,
    required int userId,
    required File imageFile,
  }) async {
    final result = await Get.showOverlay(
      asyncFunction: () => ShipperService().confirmDelivery(
        orderId: order.id,
        userId: userId,
        status: "DELIVERED",
        avatarImage: imageFile,
      ),
      loadingWidget: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (result.success) {
      final index = orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        orders[index].status = 'DELIVERED';
        orders.refresh();
      }
      Get.snackbar(
        "✅ Thành công",
        "Đơn hàng #${order.id} đã được giao.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar("❌ Lỗi", result.message);
    }
  }

  void updateOrderInList(Order updated) {
    final index = orders.indexWhere((o) => o.id == updated.id);
    if (index != -1) {
      orders[index] = updated;
      orders.refresh(); // 🔄 Cập nhật Obx UI
    }
  }

  /// Delivery images
  final RxMap<int, Rxn<File>> deliveryImages = <int, Rxn<File>>{}.obs;

  Future<void> pickDeliveryImage(int orderId) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      deliveryImages[orderId] = Rxn(File(picked.path));
    }
  }

  void removeDeliveryImage(int orderId) {
    deliveryImages.remove(orderId);
  }

  Future<void> callPhoneNumber(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar("Lỗi", "Không thể mở ứng dụng gọi điện");
    }
  }

}
