import 'package:get/get.dart';
import '../../../models/delivery.dart';
import '../../../models/order.dart';
import '../../../models/payment.dart';
import '../../../models/voucher.dart';
import '../../../service/delivery_method_service.dart';
import '../../../service/order_service.dart';
import '../../../service/payment_service.dart';
import '../../../service/voucher_service.dart';

class CheckOutController extends GetxController {
  final OrderService orderService = OrderService();
  final VoucherService voucherService = VoucherService();
  final DeliveryMethodService deliveryMethodService = DeliveryMethodService();
  final PaymentService paymentService = PaymentService();



  var orders = <Order>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var vouchers = <Voucher>[].obs;
  var isLoadingVouchers = false.obs;
  var errorMessageVouchers = ''.obs;

  var deliveryMethods = <DeliveryDTO>[].obs;
  var isLoadingDeliveryMethods = false.obs;
  var errorMessageDeliveryMethods = ''.obs;

  // Thêm state cho payment methods
  var paymentMethods = <PaymentModel>[].obs;
  var isLoadingPaymentMethods = false.obs;
  var errorMessagePaymentMethods = ''.obs;
  var selectedPaymentMethod = Rxn<PaymentModel>();

  int? orderId;
  var order = Rxn<Order>();

  @override
  void onInit() {
    super.onInit();
    final passedOrder = Get.arguments as Order?;
    if (passedOrder != null) {
      order.value = passedOrder;
      orderId = passedOrder.id;
      fetchDeliveryMethods(passedOrder.shopId);
      fetchVouchers(passedOrder.shopId);
      fetchPaymentMethods(); // Thêm dòng này
    } else {
      errorMessage.value = "Không có dữ liệu đơn hàng được truyền sang.";
    }
  }

  Future<void> fetchPaymentMethods() async {
    try {
      isLoadingPaymentMethods.value = true;
      errorMessagePaymentMethods.value = '';

      final response = await paymentService.getPayments(0, 10, 'name,asc');
      if (response.containsKey('content')) {
        paymentMethods.value = (response['content'] as List)
            .map((item) => PaymentModel.fromJson(item))
            .toList();

        // Tự động chọn phương thức đầu tiên
        if (paymentMethods.isNotEmpty) {
          selectedPaymentMethod.value = paymentMethods.first;
        }
      }
    } catch (e) {
      errorMessagePaymentMethods.value = 'Lỗi khi tải phương thức thanh toán: $e';
    } finally {
      isLoadingPaymentMethods.value = false;
    }
  }

  Future<void> updateOrderTotal(double newTotal) async {
    if (order.value == null) return;

    try {
      await orderService.updateOrderTotal(
        orderId: order.value!.id, // ID của đơn hàng hiện tại
        newTotal: newTotal, // Tổng tiền mới
      );

      // Cập nhật lại giá trị total trong order
      order.update((val) {
        if (val != null) {
          val.total = newTotal;
        }
      });

      // // Cập nhật UI
      // Get.snackbar('Thành công', 'Đã cập nhật tổng tiền!',
      //     snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật tổng tiền. Vui lòng thử lại.',
          snackPosition: SnackPosition.BOTTOM);
      print("❌ Lỗi updateOrderTotal: $e");
    }
  }


  Future<void> fetchDeliveryMethods(int? shopId) async {
    if (shopId == null) return;

    try {
      isLoadingDeliveryMethods.value = true;
      errorMessageDeliveryMethods.value = '';

      final methods = await deliveryMethodService.getDeliveryMethodsByShop(shopId);
      deliveryMethods.value = methods;

      if (methods.isNotEmpty) {
        // Cập nhật phương thức giao hàng mặc định
        selectDeliveryMethod(methods.first);
      }
    } catch (e) {
      errorMessageDeliveryMethods.value = 'Lỗi khi tải phương thức giao hàng: $e';
    } finally {
      isLoadingDeliveryMethods.value = false;
    }
  }

  void selectDeliveryMethod(DeliveryDTO method) {
    order.update((val) {
      if (val != null) {
        val.shipMethodId = method.id;
        val.shipMethodName = method.name;
        val.shippingFee = method.fee; // Cập nhật phí giao hàng vào đơn hàng
      }
    });

    // Tính toán lại tổng tiền sau khi thay đổi phương thức giao hàng
    double currentTotal = order.value?.total ?? 0;
    double newTotal = currentTotal + method.fee;

    // Gọi API cập nhật tổng tiền
    updateOrderTotal(newTotal);

  }

  void selectPaymentMethod(PaymentModel method) {
    selectedPaymentMethod.value = method;

    // Cập nhật vào order nếu cần
    order.update((val) {
      if (val != null) {
        val.paymentMethodId = method.id;
        val.paymentMethodName = method.name;
      }
    });
  }

  Future<void> updatePaymentMethodAndShipping() async {
    if (order.value == null || selectedPaymentMethod.value == null) return;

    final shipMethodId = order.value?.shipMethodId;
    final payMethodId = selectedPaymentMethod.value?.id;

    if (shipMethodId == null || payMethodId == null) {
      Get.snackbar('Lỗi', 'Vui lòng chọn phương thức giao hàng và thanh toán.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      // Gọi API update phương thức giao hàng và thanh toán
      await orderService.updatePaymentMethodAndShipping(
        order.value!.id, // orderId
        shipMethodId, // shipId
        payMethodId, // payId
      );

      // Sau khi cập nhật thành công, thông báo cho người dùng
      // Get.snackbar('Thành công', 'Đã cập nhật phương thức giao hàng và thanh toán!',
      //     snackPosition: SnackPosition.BOTTOM);

      // Nếu bạn muốn thực hiện một hành động tiếp theo, ví dụ: chuyển sang màn hình khác
      if (payMethodId == 1) {
        // Tiền mặt, chuyển đến my-order
        Get.toNamed('/my-order', arguments: order.value?.ownerId);
      } else if (payMethodId == 2) {
        // Chuyển khoản ngân hàng, chuyển đến QR Payment
        Get.toNamed('/qr-payment', arguments: order.value);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật phương thức thanh toán và giao hàng.',
          snackPosition: SnackPosition.BOTTOM);
      print("❌ Lỗi updatePaymentMethodAndShipping: $e");
    }
  }


  Future<void> fetchOrder() async {
    if (orderId == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedOrder = await orderService.fetchOrderById(orderId!);
      if (fetchedOrder != null) {
        order.value = fetchedOrder;
      } else {
        errorMessage.value = 'Không tìm thấy đơn hàng.';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVouchers(int? shopId) async {
    if (shopId == null) return;

    try {
      isLoadingVouchers.value = true;
      errorMessageVouchers.value = '';

      final fetchedVouchers = await voucherService.fetchVouchersByShopId(shopId);
      if (fetchedVouchers != null) {
        vouchers.value = fetchedVouchers;
      } else {
        errorMessageVouchers.value = 'Không tìm thấy voucher cho cửa hàng này.';
      }
    } catch (e) {
      errorMessageVouchers.value = e.toString();
    } finally {
      isLoadingVouchers.value = false;
    }
  }

  Future<Order?> placeOrder(Order orderToPlace) async {
    try {
      isLoading.value = true;

      // Kiểm tra đã chọn phương thức giao hàng chưa
      if (orderToPlace.shipMethodId == null || orderToPlace.shipMethodId == 0) {
        throw Exception('Vui lòng chọn phương thức giao hàng');
      }


      final createdOrders = await orderService.createOrder(orderToPlace);
      if (createdOrders.isNotEmpty) {
        final newOrder = createdOrders.first;
        order.value = newOrder;
        orders.assignAll(createdOrders);
        Get.snackbar('Thành công', 'Đặt hàng thành công!',
            snackPosition: SnackPosition.BOTTOM);
        return newOrder;
      } else {
        throw Exception('Không tạo được đơn hàng');
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
