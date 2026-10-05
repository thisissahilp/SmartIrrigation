// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/in_app_alert.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool get initialized => _initialized;

  // Settings Toggles
  bool masterEnabled = true;
  bool enableSafetyEvents = true;
  bool enableIrrigationEvents = true;
  bool enableMissedEvents = true;
  bool enableReminderEvents = true;
  bool enableConnectionEvents = true;
  bool enableDailySummary = false;

  // Active In-App Visual Alerts
  final List<InAppAlert> _activeAlerts = [];
  List<InAppAlert> get activeAlerts => List.unmodifiable(_activeAlerts.where((a) => !a.isDismissed));

  // Deduplication set for notified event IDs
  final Set<String> _notifiedEventIds = {};

  // Stream controller for tap deep-linking navigation ('dashboard', 'history', 'schedules')
  final StreamController<String> _navigationStreamController = StreamController<String>.broadcast();
  Stream<String> get navigationStream => _navigationStreamController.stream;

  // Notification Channels
  static const AndroidNotificationChannel _safetyChannel = AndroidNotificationChannel(
    'smart_farm_safety',
    'Safety & Watchdog Alerts',
    description: 'Critical safety alerts and Arduino watchdog shutdown notifications',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  static const AndroidNotificationChannel _irrigationChannel = AndroidNotificationChannel(
    'smart_farm_irrigation',
    'Irrigation Events',
    description: 'Notifications for completed, started, or missed irrigation sessions',
    importance: Importance.high,
  );

  static const AndroidNotificationChannel _remindersChannel = AndroidNotificationChannel(
    'smart_farm_reminders',
    'Irrigation Reminders',
    description: 'Upcoming schedule reminders and daily summaries',
    importance: Importance.defaultImportance,
  );

  static const AndroidNotificationChannel _systemChannel = AndroidNotificationChannel(
    'smart_farm_system',
    'System & Connection Events',
    description: 'Bluetooth status and controller connection alerts',
    importance: Importance.low,
  );

  Future<void> init() async {
    if (_initialized) return;

    await _loadPreferences();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    try {
      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null && response.payload!.isNotEmpty) {
            _navigationStreamController.add(response.payload!);
          }
        },
      );

      final androidImpl = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        await androidImpl.createNotificationChannel(_safetyChannel);
        await androidImpl.createNotificationChannel(_irrigationChannel);
        await androidImpl.createNotificationChannel(_remindersChannel);
        await androidImpl.createNotificationChannel(_systemChannel);
      }
    } catch (e) {
      print('NotificationService.init error: $e');
    }

    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      masterEnabled = prefs.getBool('notif_master') ?? true;
      enableSafetyEvents = prefs.getBool('notif_safety') ?? true;
      enableIrrigationEvents = prefs.getBool('notif_irrigation') ?? true;
      enableMissedEvents = prefs.getBool('notif_missed') ?? true;
      enableReminderEvents = prefs.getBool('notif_reminders') ?? true;
      enableConnectionEvents = prefs.getBool('notif_connection') ?? true;
      enableDailySummary = prefs.getBool('notif_daily_summary') ?? false;
    } catch (e) {
      print('NotificationService._loadPreferences error: $e');
    }
  }

  Future<void> savePreferences({
    required bool master,
    required bool safety,
    required bool irrigation,
    required bool missed,
    required bool reminders,
    required bool connection,
    required bool dailySummary,
  }) async {
    masterEnabled = master;
    enableSafetyEvents = safety;
    enableIrrigationEvents = irrigation;
    enableMissedEvents = missed;
    enableReminderEvents = reminders;
    enableConnectionEvents = connection;
    enableDailySummary = dailySummary;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notif_master', master);
      await prefs.setBool('notif_safety', safety);
      await prefs.setBool('notif_irrigation', irrigation);
      await prefs.setBool('notif_missed', missed);
      await prefs.setBool('notif_reminders', reminders);
      await prefs.setBool('notif_connection', connection);
      await prefs.setBool('notif_daily_summary', dailySummary);
    } catch (e) {
      print('NotificationService.savePreferences error: $e');
    }

    notifyListeners();
  }

  Future<bool> checkPermission() async {
    return await Permission.notification.isGranted;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    notifyListeners();
    return status.isGranted;
  }

  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }

  /// Manually dismiss an in-app visual alert banner
  void dismissAlert(String alertId) {
    final index = _activeAlerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _activeAlerts[index].isDismissed = true;
      notifyListeners();
    }
  }

  /// Trigger Safety Interruption Alert (BLE Lost while Pump ON)
  Future<void> triggerSafetyInterruptionAlert({
    required String eventId,
    required String title,
    required String message,
    required String actionLabel,
  }) async {
    if (_notifiedEventIds.contains(eventId)) return;
    _notifiedEventIds.add(eventId);

    // 1. Add to In-App Alerts Layer
    _activeAlerts.removeWhere((a) => a.id == eventId);
    _activeAlerts.insert(
      0,
      InAppAlert(
        id: eventId,
        severity: AlertSeverity.safety,
        title: title,
        message: message,
        actionLabel: actionLabel,
        routePayload: 'history',
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();

    // 2. Android System Notification Layer
    if (masterEnabled && enableSafetyEvents) {
      await _showSystemNotification(
        id: eventId.hashCode,
        title: title,
        body: message,
        channel: _safetyChannel,
        payload: 'history',
      );
    }
  }

  /// Trigger Connection Restored Alert
  Future<void> triggerConnectionRestoredAlert({
    required String eventId,
    required String title,
    required String message,
    required String actionLabel,
  }) async {
    if (_notifiedEventIds.contains(eventId)) return;
    _notifiedEventIds.add(eventId);

    _activeAlerts.insert(
      0,
      InAppAlert(
        id: eventId,
        severity: AlertSeverity.info,
        title: title,
        message: message,
        actionLabel: actionLabel,
        routePayload: 'history',
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();

    if (masterEnabled && enableConnectionEvents) {
      await _showSystemNotification(
        id: eventId.hashCode,
        title: title,
        body: message,
        channel: _systemChannel,
        payload: 'history',
      );
    }
  }

  /// Trigger Missed Irrigation Alert
  Future<void> triggerMissedIrrigationAlert({
    required String eventId,
    required String title,
    required String message,
    required String actionLabel,
  }) async {
    if (_notifiedEventIds.contains(eventId)) return;
    _notifiedEventIds.add(eventId);

    _activeAlerts.insert(
      0,
      InAppAlert(
        id: eventId,
        severity: AlertSeverity.warning,
        title: title,
        message: message,
        actionLabel: actionLabel,
        routePayload: 'schedules',
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();

    if (masterEnabled && enableMissedEvents) {
      await _showSystemNotification(
        id: eventId.hashCode,
        title: title,
        body: message,
        channel: _irrigationChannel,
        payload: 'schedules',
      );
    }
  }

  /// Trigger Irrigation Completed Notification
  Future<void> triggerIrrigationCompletedNotification({
    required String eventId,
    required String title,
    required String message,
  }) async {
    if (_notifiedEventIds.contains(eventId)) return;
    _notifiedEventIds.add(eventId);

    if (masterEnabled && enableIrrigationEvents) {
      await _showSystemNotification(
        id: eventId.hashCode,
        title: title,
        body: message,
        channel: _irrigationChannel,
        payload: 'history',
      );
    }
  }

  /// Trigger Upcoming Reminder Notification
  Future<void> triggerUpcomingReminderNotification({
    required String eventId,
    required String title,
    required String message,
  }) async {
    if (_notifiedEventIds.contains(eventId)) return;
    _notifiedEventIds.add(eventId);

    if (masterEnabled && enableReminderEvents) {
      await _showSystemNotification(
        id: eventId.hashCode,
        title: title,
        body: message,
        channel: _remindersChannel,
        payload: 'schedules',
      );
    }
  }

  /// Trigger Weather Rain Warning Notification
  Future<void> triggerWeatherRainWarningNotification({
    required String eventId,
    required String title,
    required String message,
  }) async {
    if (_notifiedEventIds.contains(eventId)) return;
    _notifiedEventIds.add(eventId);

    if (masterEnabled && enableReminderEvents) {
      await _showSystemNotification(
        id: eventId.hashCode,
        title: title,
        body: message,
        channel: _remindersChannel,
        payload: 'schedules',
      );
    }
  }

  Future<void> _showSystemNotification({
    required int id,
    required String title,
    required String body,
    required AndroidNotificationChannel channel,
    String? payload,
  }) async {
    if (!_initialized) await init();

    try {
      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(body),
      );
      final notificationDetails = NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      print('showSystemNotification exception: $e');
    }
  }
}
