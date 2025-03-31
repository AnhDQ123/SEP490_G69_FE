import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

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

}
