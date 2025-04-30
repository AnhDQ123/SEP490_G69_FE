import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_connect/connect.dart';
import 'package:permission_handler/permission_handler.dart';

import '../base/api_base_url.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // ✅ Xin quyền nếu là Android 13+
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      if (!result.isGranted) {
        log("⚠️ Người dùng không cấp quyền thông báo, sẽ không hiển thị được notification.");
        return;
      }
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _notifications.initialize(initSettings);
  }

  static Future<void> showOrderSuccessNotification(String message) async {
    log("🔔 Bắt đầu gọi showOrderSuccessNotification với message: $message");

    try {
      const androidDetails = AndroidNotificationDetails(
        'order_channel_id',
        'Đơn hàng',
        channelDescription: 'Thông báo đơn hàng',
        importance: Importance.max,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _notifications.show(
        0,
        '✅ Xác nhận thanh toán',
        message,
        notificationDetails,
      );

      log("✅ Notification đã hiển thị thành công");
    } catch (e) {
      log("❌ Lỗi khi show notification: $e");
    }
  }

  static Future<void> showNewOrderNotification(int totalOrders) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'new_order_channel_id', // 🔥 Channel riêng
        'Đơn hàng mới',
        channelDescription: 'Thông báo đơn hàng mới cần xử lý',
        importance: Importance.max,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _notifications.show(
        2, // 🔥 ID khác các notification khác
        '📦 Có đơn hàng mới!',
        'Bạn có $totalOrders đơn hàng mới cần xác nhận giao.',
        notificationDetails,
      );

      log("✅ Notification đơn hàng mới đã hiển thị.");
    } catch (e) {
      log("❌ Lỗi khi showNewOrderNotification: $e");
    }
  }


  static Future<void> showCartReminderNotification(int totalItems) async {
    const androidDetails = AndroidNotificationDetails(
      'cart_channel_id',
      'Giỏ hàng',
      channelDescription: 'Thông báo nhắc nhở giỏ hàng',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      1,
      '🛒 Bạn có sản phẩm trong giỏ hàng!',
      'Bạn đang có $totalItems sản phẩm đang chờ thanh toán.',
      notificationDetails,
    );
  }

  static Future<void> sendNotificationFromServer({
    required String token,
    required String title,
    required String body,
  }) async {
    final apiUrl = "${ApiBaseUrl.baseUrl}/api/noti/sendNotification";

    try {
      final response = await GetConnect().post(
        apiUrl,
        {},
        query: {
          'token': token,
          'title': title,
          'body': body,
        },
      );

      if (response.statusCode == 200) {
        print("✅ Server đã gửi notification thành công.");
      } else {
        print("❌ Server gửi thất bại: ${response.bodyString}");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API gửi notification: $e");
    }
  }

  static Future<void> showDeliveredOrdersNotification(int totalDelivered) async {
    if (totalDelivered == 0) return;

    try {
      const androidDetails = AndroidNotificationDetails(
        'delivered_order_channel',
        'Đơn hàng đã giao',
        channelDescription: 'Thông báo khi đơn hàng đã giao thành công',
        importance: Importance.max,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _notifications.show(
        3, // 🔔 ID khác với các notification khác
        '📦 Đơn hàng đã giao',
        'Bạn có $totalDelivered đơn hàng đã được giao thành công.',
        notificationDetails,
      );

      log("✅ Đã hiển thị thông báo đơn đã giao");
    } catch (e) {
      log("❌ Lỗi khi hiển thị notification đơn đã giao: $e");
    }
  }

  static Future<void> showPendingOrdersNotification(int totalPending) async {
    if (totalPending == 0) return;

    try {
      const androidDetails = AndroidNotificationDetails(
        'pending_order_channel',
        'Đơn hàng chờ xác nhận',
        channelDescription: 'Thông báo đơn hàng mới chờ xác nhận của shop',
        importance: Importance.max,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _notifications.show(
        4, // 🔔 Đảm bảo khác ID với các notification khác
        '🕐 Đơn hàng mới',
        'Bạn có $totalPending đơn hàng đang chờ xác nhận!',
        notificationDetails,
      );

      log("✅ Đã hiển thị thông báo đơn chờ xác nhận");
    } catch (e) {
      log("❌ Lỗi khi hiển thị thông báo đơn chờ xác nhận: $e");
    }
  }






}
