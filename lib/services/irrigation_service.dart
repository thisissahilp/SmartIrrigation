import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../models/irrigation_schedule.dart';
import '../models/irrigation_session.dart';
import 'notification_service.dart';
import 'settings_service.dart';
import 'storage_service.dart';

enum ActiveIrrigationState {
  idle,
  manual,
  timer,
  scheduled,
  interruptedUnknown,
}

class IrrigationService extends ChangeNotifier {
  // Singleton instance
  static final IrrigationService _instance = IrrigationService._internal();
  factory IrrigationService() => _instance;
  IrrigationService._internal();

  final StorageService _storage = StorageService();
  final BluetoothService _bluetooth = BluetoothService();

  bool _initialized = false;
  bool get initialized => _initialized;

  List<IrrigationSchedule> _schedules = [];
  List<IrrigationSchedule> get schedules => List.unmodifiable(_schedules);

  List<IrrigationSession> _history = [];
  List<IrrigationSession> get history => List.unmodifiable(_history);

  ActiveIrrigationState _activeState = ActiveIrrigationState.idle;
  ActiveIrrigationState get activeState => _activeState;

  IrrigationSession? _activeSession;
  IrrigationSession? get activeSession => _activeSession;

  IrrigationSession? _lastInterruptedSession;
  IrrigationSession? get lastInterruptedSession => _lastInterruptedSession;

  int _activeElapsedSeconds = 0;
  int get activeElapsedSeconds => _activeElapsedSeconds;

  int _activeRemainingSeconds = 0;
  int get activeRemainingSeconds => _activeRemainingSeconds;

  Timer? _tickerTimer;
  Timer? _scheduleCheckerTimer;

  bool _wasDisconnectedAfterInterruption = false;

  // Track triggered schedule minutes: 'scheduleId_YYYYMMDD_HHmm'
  final Set<String> _triggeredScheduleKeys = {};
  final Set<String> _skippedScheduleKeys = {};
  final Set<String> _dismissedRainWarningKeys = {};

  bool isScheduleSkippedToday(String scheduleId) {
    final now = DateTime.now();
    return _skippedScheduleKeys.contains('skip_${scheduleId}_${now.year}${now.month}${now.day}');
  }

  bool isRainWarningDismissedToday(String scheduleId) {
    final now = DateTime.now();
    return _dismissedRainWarningKeys.contains('dismiss_rain_${scheduleId}_${now.year}${now.month}${now.day}');
  }

  Future<void> skipScheduleOnce(IrrigationSchedule schedule, {String? reason}) async {
    final now = DateTime.now();
    final dateKey = '${now.year}${now.month}${now.day}';
    final skipKey = 'skip_${schedule.id}_$dateKey';

    if (_skippedScheduleKeys.contains(skipKey)) return;

    _skippedScheduleKeys.add(skipKey);

    final skippedSession = IrrigationSession(
      id: now.millisecondsSinceEpoch.toString(),
      startTime: now,
      endTime: now,
      requestedDuration: schedule.duration,
      confirmedRuntime: Duration.zero,
      source: IrrigationSource.scheduled,
      status: IrrigationStatus.cancelled,
      interruptionReason: reason ?? 'Skipped once by farmer due to rain forecast.',
      scheduleName: schedule.name,
    );

    _addHistorySession(skippedSession);
    _bluetooth.addActivityLog('Schedule Skipped', '${schedule.name} skipped for today.');
    notifyListeners();
  }

  void dismissRainWarningForSchedule(String scheduleId) {
    final now = DateTime.now();
    final dateKey = '${now.year}${now.month}${now.day}';
    _dismissedRainWarningKeys.add('dismiss_rain_${scheduleId}_$dateKey');
    _bluetooth.addActivityLog('Irrigate Anyway', 'Rain warning overridden for schedule $scheduleId.');
    notifyListeners();
  }

  bool get isIrrigationActive =>
      _activeState == ActiveIrrigationState.manual ||
      _activeState == ActiveIrrigationState.timer ||
      _activeState == ActiveIrrigationState.scheduled;

  void clearLastInterruptedSession() {
    _lastInterruptedSession = null;
    notifyListeners();
  }

  /// Initialize service, load persisted data, and register listeners
  Future<void> init() async {
    if (_initialized) return;

    _schedules = await _storage.loadSchedules();
    _history = await _storage.loadHistory();

    // Listen to BluetoothService changes to detect connection drops
    _bluetooth.addListener(_onBluetoothStateChanged);

    // Start schedule checker timer (runs every 5 seconds)
    _scheduleCheckerTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkSchedules();
    });

    _initialized = true;
    notifyListeners();
  }

  void _onBluetoothStateChanged() {
    // Check if BLE connection dropped while pump was ON or session active
    final isConnected = _bluetooth.connectionState == BtcConnectionState.connected;

    if (!isConnected && (isIrrigationActive || _bluetooth.isPumpOn)) {
      _wasDisconnectedAfterInterruption = true;
      _handleInterruption(
        reason: 'Connection lost — Arduino safety watchdog will turn the pump OFF.',
      );
    } else if (isConnected && _wasDisconnectedAfterInterruption) {
      _wasDisconnectedAfterInterruption = false;
      final settings = SettingsService();
      NotificationService().triggerConnectionRestoredAlert(
        eventId: 'reconnect_${DateTime.now().millisecondsSinceEpoch}',
        title: settings.tr('reconnectedTitle'),
        message: settings.tr('reconnectedBody'),
        actionLabel: settings.tr('viewHistory'),
      );
    }
  }

  /// Handle connection interruption while pump was ON
  void _handleInterruption({required String reason}) {
    if (_activeState == ActiveIrrigationState.interruptedUnknown && _bluetooth.isPumpOn == false) {
      return;
    }

    _tickerTimer?.cancel();
    _tickerTimer = null;

    final now = DateTime.now();
    final startTime = _activeSession?.startTime ?? now;
    final confirmedRuntime = now.difference(startTime);
    final reqDuration = _activeSession?.requestedDuration ?? confirmedRuntime;
    final source = _activeSession?.source ?? IrrigationSource.manual;
    final scheduleName = _activeSession?.scheduleName;

    final session = IrrigationSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: startTime,
      endTime: now,
      requestedDuration: reqDuration,
      confirmedRuntime: confirmedRuntime,
      source: source,
      status: IrrigationStatus.interrupted,
      interruptionReason: reason,
      scheduleName: scheduleName,
    );

    _addHistorySession(session);
    _lastInterruptedSession = session;
    _activeState = ActiveIrrigationState.interruptedUnknown;
    _activeSession = null;
    _activeElapsedSeconds = 0;
    _activeRemainingSeconds = 0;

    _bluetooth.addActivityLog(
      '⚠️ Interrupted',
      'Connection lost while pump was ON. Arduino watchdog safety timeout initiated.',
    );

    final settings = SettingsService();
    NotificationService().triggerSafetyInterruptionAlert(
      eventId: 'interruption_${session.id}',
      title: settings.tr('safetyAlertTitle'),
      message: settings.tr('safetyAlertBody'),
      actionLabel: settings.tr('viewHistory'),
    );

    notifyListeners();
  }

  /// Start manual pump irrigation
  Future<bool> startManualIrrigation() async {
    if (isIrrigationActive) {
      _bluetooth.addActivityLog('Blocked', 'Irrigation already running.');
      notifyListeners();
      return false;
    }

    if (_bluetooth.connectionState != BtcConnectionState.connected) {
      return false;
    }

    final success = await _bluetooth.sendCommand('1', actionDescription: 'Manual Pump ON');
    if (!success) return false;

    final now = DateTime.now();
    _activeSession = IrrigationSession(
      id: now.millisecondsSinceEpoch.toString(),
      startTime: now,
      requestedDuration: Duration.zero,
      confirmedRuntime: Duration.zero,
      source: IrrigationSource.manual,
      status: IrrigationStatus.completed,
    );

    _activeState = ActiveIrrigationState.manual;
    _activeElapsedSeconds = 0;
    _activeRemainingSeconds = 0;

    _startTicker();
    notifyListeners();
    return true;
  }

  /// Stop manual pump irrigation
  Future<bool> stopManualIrrigation() async {
    if (_activeState != ActiveIrrigationState.manual && !_bluetooth.isPumpOn) {
      return false;
    }

    final success = await _bluetooth.sendCommand('0', actionDescription: 'Manual Pump OFF');
    
    final now = DateTime.now();
    final startTime = _activeSession?.startTime ?? now;
    final confirmedRuntime = now.difference(startTime);

    final session = IrrigationSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: startTime,
      endTime: now,
      requestedDuration: confirmedRuntime,
      confirmedRuntime: confirmedRuntime,
      source: IrrigationSource.manual,
      status: IrrigationStatus.completed,
    );

    _addHistorySession(session);

    _stopTicker();
    _activeState = ActiveIrrigationState.idle;
    _activeSession = null;
    notifyListeners();

    return success;
  }

  /// Start custom countdown timer irrigation
  Future<bool> startTimerIrrigation(Duration duration) async {
    if (isIrrigationActive) {
      _bluetooth.addActivityLog('Blocked', 'Irrigation already running.');
      notifyListeners();
      return false;
    }

    if (_bluetooth.connectionState != BtcConnectionState.connected) {
      return false;
    }

    final success = await _bluetooth.sendCommand(
      '1',
      actionDescription: 'Timer Pump ON (${duration.inMinutes}m ${duration.inSeconds % 60}s)',
    );
    if (!success) return false;

    final now = DateTime.now();
    _activeSession = IrrigationSession(
      id: now.millisecondsSinceEpoch.toString(),
      startTime: now,
      requestedDuration: duration,
      confirmedRuntime: Duration.zero,
      source: IrrigationSource.timer,
      status: IrrigationStatus.completed,
    );

    _activeState = ActiveIrrigationState.timer;
    _activeElapsedSeconds = 0;
    _activeRemainingSeconds = duration.inSeconds;

    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _activeElapsedSeconds++;
      if (_activeRemainingSeconds > 0) {
        _activeRemainingSeconds--;
      }

      if (_activeRemainingSeconds <= 0) {
        timer.cancel();
        _tickerTimer = null;

        await _bluetooth.sendCommand('0', actionDescription: 'Timer completed - Pump OFF');

        final end = DateTime.now();
        final start = _activeSession?.startTime ?? end;
        final confirmed = end.difference(start);

        final completedSession = IrrigationSession(
          id: end.millisecondsSinceEpoch.toString(),
          startTime: start,
          endTime: end,
          requestedDuration: duration,
          confirmedRuntime: confirmed,
          source: IrrigationSource.timer,
          status: IrrigationStatus.completed,
        );

        _addHistorySession(completedSession);
        _activeState = ActiveIrrigationState.idle;
        _activeSession = null;

        final settings = SettingsService();
        NotificationService().triggerIrrigationCompletedNotification(
          eventId: 'timer_complete_${completedSession.id}',
          title: settings.tr('irrigationCompletedTitle'),
          message: '${settings.tr('irrigationCompletedBody')} (${duration.inMinutes}m)',
        );

        notifyListeners();
      } else {
        notifyListeners();
      }
    });

    notifyListeners();
    return true;
  }

  /// Cancel active countdown timer
  Future<void> cancelTimerIrrigation() async {
    if (_activeState != ActiveIrrigationState.timer && _activeState != ActiveIrrigationState.scheduled) {
      return;
    }

    _tickerTimer?.cancel();
    _tickerTimer = null;

    await _bluetooth.sendCommand('0', actionDescription: 'Irrigation cancelled by user');

    final now = DateTime.now();
    final start = _activeSession?.startTime ?? now;
    final confirmed = now.difference(start);

    final cancelledSession = IrrigationSession(
      id: now.millisecondsSinceEpoch.toString(),
      startTime: start,
      endTime: now,
      requestedDuration: _activeSession?.requestedDuration ?? confirmed,
      confirmedRuntime: confirmed,
      source: _activeSession?.source ?? IrrigationSource.timer,
      status: IrrigationStatus.cancelled,
      scheduleName: _activeSession?.scheduleName,
    );

    _addHistorySession(cancelledSession);
    _activeState = ActiveIrrigationState.idle;
    _activeSession = null;
    _activeElapsedSeconds = 0;
    _activeRemainingSeconds = 0;
    notifyListeners();
  }

  /// Internal ticker for manual mode elapsed time
  void _startTicker() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _activeElapsedSeconds++;
      notifyListeners();
    });
  }

  void _stopTicker() {
    _tickerTimer?.cancel();
    _tickerTimer = null;
    _activeElapsedSeconds = 0;
    _activeRemainingSeconds = 0;
  }

  /// Periodically check if any enabled schedule should trigger
  void _checkSchedules() {
    final now = DateTime.now();

    for (final schedule in _schedules) {
      if (!schedule.enabled) continue;

      // Check 15 minutes before schedule start for upcoming reminder
      final scheduleTotalMinutes = schedule.startTime.hour * 60 + schedule.startTime.minute;
      final nowTotalMinutes = now.hour * 60 + now.minute;
      final reminderTotalMinutes = (scheduleTotalMinutes - 15 + 1440) % 1440;

      if (nowTotalMinutes == reminderTotalMinutes) {
        final reminderKey = 'upcoming_${schedule.id}_${now.year}${now.month}${now.day}';
        if (!_triggeredScheduleKeys.contains(reminderKey)) {
          _triggeredScheduleKeys.add(reminderKey);
          final settings = SettingsService();
          NotificationService().triggerUpcomingReminderNotification(
            eventId: reminderKey,
            title: settings.tr('upcomingIrrigationTitle'),
            message: '${schedule.name}: ${settings.tr('upcomingIrrigationBody')}',
          );
        }
      }

      if (schedule.startTime.hour == now.hour && schedule.startTime.minute == now.minute) {
        final skipKey = 'skip_${schedule.id}_${now.year}${now.month}${now.day}';
        if (_skippedScheduleKeys.contains(skipKey)) {
          _bluetooth.addActivityLog('Schedule Skipped', '${schedule.name} skipped for today due to farmer choice.');
          continue;
        }

        final triggerKey = '${schedule.id}_${now.year}${now.month}${now.day}_${now.hour}${now.minute}';
        if (_triggeredScheduleKeys.contains(triggerKey)) continue;

        _triggeredScheduleKeys.add(triggerKey);

        _executeSchedule(schedule, now);
      }
    }
  }

  /// Execute triggered schedule
  Future<void> _executeSchedule(IrrigationSchedule schedule, DateTime now) async {
    final isConnected = _bluetooth.connectionState == BtcConnectionState.connected;

    // IF BLE IS NOT CONNECTED
    if (!isConnected) {
      final missedSession = IrrigationSession(
        id: now.millisecondsSinceEpoch.toString(),
        startTime: now,
        endTime: now,
        requestedDuration: schedule.duration,
        confirmedRuntime: Duration.zero,
        source: IrrigationSource.scheduled,
        status: IrrigationStatus.missed,
        interruptionReason: 'Scheduled irrigation missed — Bluetooth unavailable.',
        scheduleName: schedule.name,
      );

      _addHistorySession(missedSession);
      _bluetooth.addActivityLog('Missed Schedule', '${schedule.name}: Bluetooth unavailable.');

      final settings = SettingsService();
      NotificationService().triggerMissedIrrigationAlert(
        eventId: 'missed_${schedule.id}_${now.year}${now.month}${now.day}',
        title: settings.tr('missedIrrigationTitle'),
        message: '${schedule.name}: ${settings.tr('missedIrrigationBody')}',
        actionLabel: settings.tr('viewSchedules'),
      );

      notifyListeners();
      return;
    }

    // IF IRRIGATION IS ALREADY RUNNING
    if (isIrrigationActive) {
      final missedSession = IrrigationSession(
        id: now.millisecondsSinceEpoch.toString(),
        startTime: now,
        endTime: now,
        requestedDuration: schedule.duration,
        confirmedRuntime: Duration.zero,
        source: IrrigationSource.scheduled,
        status: IrrigationStatus.missed,
        interruptionReason: 'Irrigation already running.',
        scheduleName: schedule.name,
      );

      _addHistorySession(missedSession);
      _bluetooth.addActivityLog('Schedule Skipped', '${schedule.name}: Irrigation already running.');

      final settings = SettingsService();
      NotificationService().triggerMissedIrrigationAlert(
        eventId: 'missed_busy_${schedule.id}_${now.year}${now.month}${now.day}',
        title: settings.tr('missedIrrigationTitle'),
        message: '${schedule.name}: ${settings.tr('missedIrrigationBody')}',
        actionLabel: settings.tr('viewSchedules'),
      );

      notifyListeners();
      return;
    }

    // START SCHEDULED IRRIGATION
    final success = await _bluetooth.sendCommand(
      '1',
      actionDescription: 'Scheduled start: ${schedule.name} (${schedule.formattedDuration})',
    );

    if (!success) {
      final missedSession = IrrigationSession(
        id: now.millisecondsSinceEpoch.toString(),
        startTime: now,
        endTime: now,
        requestedDuration: schedule.duration,
        confirmedRuntime: Duration.zero,
        source: IrrigationSource.scheduled,
        status: IrrigationStatus.missed,
        interruptionReason: 'BLE write command failed.',
        scheduleName: schedule.name,
      );
      _addHistorySession(missedSession);

      final settings = SettingsService();
      NotificationService().triggerMissedIrrigationAlert(
        eventId: 'missed_failed_${schedule.id}_${now.year}${now.month}${now.day}',
        title: settings.tr('missedIrrigationTitle'),
        message: '${schedule.name}: ${settings.tr('missedIrrigationBody')}',
        actionLabel: settings.tr('viewSchedules'),
      );

      notifyListeners();
      return;
    }

    _activeSession = IrrigationSession(
      id: now.millisecondsSinceEpoch.toString(),
      startTime: now,
      requestedDuration: schedule.duration,
      confirmedRuntime: Duration.zero,
      source: IrrigationSource.scheduled,
      status: IrrigationStatus.completed,
      scheduleName: schedule.name,
    );

    _activeState = ActiveIrrigationState.scheduled;
    _activeElapsedSeconds = 0;
    _activeRemainingSeconds = schedule.duration.inSeconds;

    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _activeElapsedSeconds++;
      if (_activeRemainingSeconds > 0) {
        _activeRemainingSeconds--;
      }

      if (_activeRemainingSeconds <= 0) {
        timer.cancel();
        _tickerTimer = null;

        await _bluetooth.sendCommand('0', actionDescription: 'Schedule completed: ${schedule.name}');

        final end = DateTime.now();
        final start = _activeSession?.startTime ?? end;
        final confirmed = end.difference(start);

        final completedSession = IrrigationSession(
          id: end.millisecondsSinceEpoch.toString(),
          startTime: start,
          endTime: end,
          requestedDuration: schedule.duration,
          confirmedRuntime: confirmed,
          source: IrrigationSource.scheduled,
          status: IrrigationStatus.completed,
          scheduleName: schedule.name,
        );

        _addHistorySession(completedSession);
        _activeState = ActiveIrrigationState.idle;
        _activeSession = null;

        final settings = SettingsService();
        NotificationService().triggerIrrigationCompletedNotification(
          eventId: 'schedule_complete_${completedSession.id}',
          title: settings.tr('irrigationCompletedTitle'),
          message: '${schedule.name}: ${settings.tr('irrigationCompletedBody')}',
        );

        notifyListeners();
      } else {
        notifyListeners();
      }
    });

    notifyListeners();
  }

  void _addHistorySession(IrrigationSession session) {
    _history.insert(0, session);
    _storage.saveHistory(_history);
  }

  // SCHEDULE CRUD OPERATIONS
  Future<void> addSchedule(IrrigationSchedule schedule) async {
    _schedules.add(schedule);
    await _storage.saveSchedules(_schedules);
    notifyListeners();
  }

  Future<void> updateSchedule(IrrigationSchedule schedule) async {
    final idx = _schedules.indexWhere((s) => s.id == schedule.id);
    if (idx != -1) {
      _schedules[idx] = schedule;
      await _storage.saveSchedules(_schedules);
      notifyListeners();
    }
  }

  Future<void> deleteSchedule(String id) async {
    _schedules.removeWhere((s) => s.id == id);
    await _storage.saveSchedules(_schedules);
    notifyListeners();
  }

  Future<void> toggleSchedule(String id, bool enabled) async {
    final idx = _schedules.indexWhere((s) => s.id == id);
    if (idx != -1) {
      _schedules[idx] = _schedules[idx].copyWith(enabled: enabled);
      await _storage.saveSchedules(_schedules);
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    _history.clear();
    await _storage.clearHistory();
    notifyListeners();
  }

  // STATISTICS CALCULATIONS FOR HOME SCREEN SUMMARY
  int get todayTotalSessions {
    final now = DateTime.now();
    return _history.where((s) =>
      s.startTime.year == now.year &&
      s.startTime.month == now.month &&
      s.startTime.day == now.day
    ).length;
  }

  int get todayCompletedCount {
    final now = DateTime.now();
    return _history.where((s) =>
      s.startTime.year == now.year &&
      s.startTime.month == now.month &&
      s.startTime.day == now.day &&
      s.status == IrrigationStatus.completed
    ).length;
  }

  int get todayInterruptedCount {
    final now = DateTime.now();
    return _history.where((s) =>
      s.startTime.year == now.year &&
      s.startTime.month == now.month &&
      s.startTime.day == now.day &&
      s.status == IrrigationStatus.interrupted
    ).length;
  }

  int get todayMissedCount {
    final now = DateTime.now();
    return _history.where((s) =>
      s.startTime.year == now.year &&
      s.startTime.month == now.month &&
      s.startTime.day == now.day &&
      s.status == IrrigationStatus.missed
    ).length;
  }

  Duration get todayTotalConfirmedRuntime {
    final now = DateTime.now();
    final todaySessions = _history.where((s) =>
      s.startTime.year == now.year &&
      s.startTime.month == now.month &&
      s.startTime.day == now.day
    );
    int totalSec = 0;
    for (final s in todaySessions) {
      totalSec += s.confirmedRuntime.inSeconds;
    }
    return Duration(seconds: totalSec);
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _scheduleCheckerTimer?.cancel();
    _bluetooth.removeListener(_onBluetoothStateChanged);
    super.dispose();
  }
}
