import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum NotificationFrequency { daily, weekly, custom }

enum NotificationType {
  countdownReminder,
  milestoneReminder,
  streakReminder,
  countdownCheckpoint,
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<String?> _onNotificationClickController =
      StreamController<String?>.broadcast();
  bool _isInitialized = false;

  Stream<String?> get onNotificationClick => _onNotificationClickController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

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

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onNotificationClickController.add(response.payload);
      },
    );

    _isInitialized = true;
  }

  Future<bool> requestPermissions() async {
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final result = await android?.requestNotificationsPermission();
    
    return result ?? true;
  }

  Future<void> scheduleCountdownReminder({
    required NotificationFrequency frequency,
    required String title,
    required String body,
    int hour = 9,
    int minute = 0,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'countdown_reminders',
      'Countdown Reminders',
      channelDescription: 'Reminders for your 1356-day countdown',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    switch (frequency) {
      case NotificationFrequency.daily:
        await _notificationsPlugin.zonedSchedule(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title,
          body,
          _nextInstanceOfTime(hour, minute),
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        break;
      case NotificationFrequency.weekly:
        await _notificationsPlugin.zonedSchedule(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title,
          body,
          _nextInstanceOfDayAndTime(hour, minute),
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
        break;
      case NotificationFrequency.custom:
        break;
    }
  }

  Future<void> scheduleMilestoneReminder({
    required String goalId,
    required String goalTitle,
    required DateTime dueDate,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'milestone_reminders',
      'Milestone Reminders',
      channelDescription: 'Reminders for your goal milestones',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      int.parse(goalId.replaceAll('-', '')),
      'Milestone Due Soon',
      'Your goal "$goalTitle" has an upcoming milestone!',
      tz.TZDateTime.from(dueDate, tz.local).subtract(const Duration(days: 1)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleStreakReminder({
    required int streakDays,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'streak_reminders',
      'Streak Reminders',
      channelDescription: 'Celebrations for your active streaks',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '🔥 $streakDays Day Streak!',
      'Keep going! You\'re on fire!',
      notificationDetails,
    );
  }

  Future<void> scheduleCountdownCheckpoint({
    required String checkpointType,
    required DateTime checkpointDate,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'countdown_checkpoints',
      'Countdown Checkpoints',
      channelDescription: 'Important countdown milestones',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String title;
    String body;

    switch (checkpointType) {
      case '50_percent':
        title = 'Halfway There! 🎉';
        body = 'You\'ve completed 50% of your 1356-day journey!';
        break;
      case '25_percent':
        title = '25% Remaining ⏰';
        body = 'Only 25% of your challenge remains. Make it count!';
        break;
      default:
        title = 'Countdown Milestone';
        body = 'An important milestone in your journey has been reached!';
    }

    await _notificationsPlugin.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      tz.TZDateTime.from(checkpointDate, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  void dispose() {
    _onNotificationClickController.close();
  }
}
