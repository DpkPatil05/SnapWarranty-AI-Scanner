import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import '../../../domain/services/notification_service_interface.dart';

class NotificationService implements INotificationService {
  static final NotificationService _instance = NotificationService._();

  factory NotificationService() => _instance;

  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isRequestingPermission = false;

  @override
  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // FIX: Using named parameters for 22.x compatibility
    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        dev.log('Notification clicked: \${details.payload}');
      },
    );
  }

  @override
  Future<void> requestPermissions() async {
    if (_isRequestingPermission) return;
    _isRequestingPermission = true;

    try {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    } finally {
      _isRequestingPermission = false;
    }
  }

  @override
  Future<void> scheduleExpiryReminder({
    required String id,
    required String productName,
    required DateTime expirationDate,
  }) async {
    final int notificationId = id.hashCode.abs();

    final reminderDate = expirationDate.subtract(const Duration(days: 30));
    if (reminderDate.isAfter(DateTime.now())) {
      await _schedule(
        id: notificationId,
        title: 'Warranty Expiring Soon',
        body: 'Your warranty for "\$productName" expires in 30 days!',
        scheduledDate: reminderDate,
      );
    }

    if (expirationDate.isAfter(DateTime.now())) {
      await _schedule(
        id: notificationId + 1,
        title: 'Warranty Expired',
        body: 'The warranty for "\$productName" expires today!',
        scheduledDate: expirationDate,
      );
    }
  }

  @override
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
    try {
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
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        dev.log(
          'Exact alarms not permitted. Falling back to inexact scheduling.',
          name: 'NotificationService',
        );
        await _notifications.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'warranty_reminders_fallback',
              'Warranty Reminders (Inexact)',
              channelDescription: 'Fallback for exact alarms',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } else {
        rethrow;
      }
    }
  }
}
