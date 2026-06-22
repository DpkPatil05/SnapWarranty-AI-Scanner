import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:developer' as dev;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isRequestingPermission = false;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        dev.log('Notification clicked: ${details.payload}');
      },
    );
  }

  Future<void> requestPermissions() async {
    if (_isRequestingPermission) return;
    _isRequestingPermission = true;
    
    try {
      final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    } finally {
      _isRequestingPermission = false;
    }
  }

  Future<void> scheduleExpiryReminder({
    required String id,
    required String productName,
    required DateTime expirationDate,
  }) async {
    final int notificationId = id.hashCode.abs();
    
    // 1. Reminder: 30 days before
    final reminderDate = expirationDate.subtract(const Duration(days: 30));
    if (reminderDate.isAfter(DateTime.now())) {
      await _schedule(
        id: notificationId,
        title: 'Warranty Expiring Soon',
        body: 'Your warranty for "$productName" expires in 30 days!',
        scheduledDate: reminderDate,
      );
    }

    // 2. Reminder: On the day
    if (expirationDate.isAfter(DateTime.now())) {
      await _schedule(
        id: notificationId + 1,
        title: 'Warranty Expired',
        body: 'The warranty for "$productName" expires today!',
        scheduledDate: expirationDate,
      );
    }
  }

  Future<void> cancelReminder(String id) async {
    final int notificationId = id.hashCode.abs();
    await _notifications.cancel(id: notificationId);
    await _notifications.cancel(id: notificationId + 1);
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'warranty_reminders',
          'Warranty Reminders',
          channelDescription: 'Notifications for warranty expirations',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
