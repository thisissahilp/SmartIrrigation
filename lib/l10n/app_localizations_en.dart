// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SMART FARM';

  @override
  String get appSubtitle => 'Wireless Irrigation Controller';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get schedules => 'Schedules';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get bluetoothConnection => 'Bluetooth Connection';

  @override
  String get connected => 'Connected';

  @override
  String get connecting => 'Connecting...';

  @override
  String get disconnected => 'Disconnected';

  @override
  String pairedModuleFound(String deviceName, String macAddress) {
    return 'Paired module found: $deviceName ($macAddress). Tap Connect below.';
  }

  @override
  String get noPairedModuleFound =>
      'Ensure HC-05 module is powered and paired on your Android device before connecting.';

  @override
  String get connectDevice => 'CONNECT DEVICE';

  @override
  String get disconnectDevice => 'DISCONNECT';

  @override
  String get connectingButton => 'CONNECTING...';

  @override
  String get systemAndConnectionStatus => 'SYSTEM & CONNECTION STATUS';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get controllerHc05 => 'Controller (HC-05)';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get gattProtocol => 'GATT Protocol';

  @override
  String get ready => 'Ready (FFE0/FFE1)';

  @override
  String get notReady => 'Not Ready';

  @override
  String get watchdogSafety => 'Watchdog Safety';

  @override
  String get activePulse => 'Active (500ms pulse)';

  @override
  String get inactive => 'Inactive';

  @override
  String get pumpCommandState => 'Pump command state:';

  @override
  String get unknownDisconnected => 'UNKNOWN (Disconnected)';

  @override
  String get onCommanded => 'ON (Commanded)';

  @override
  String get off => 'OFF';

  @override
  String get lastHeartbeat => 'Last Heartbeat (\"H\"):';

  @override
  String secAgo(int count) {
    return '$count sec ago';
  }

  @override
  String get na => 'N/A';

  @override
  String get controllerDisconnectedWarning =>
      'Bluetooth connection lost while pump was ON. Arduino safety watchdog will turn pump OFF.';

  @override
  String get controllerConnectedWarning =>
      'Controller connected via Bluetooth. Stay within reliable Bluetooth range.';

  @override
  String get hardwareDisclaimer =>
      '* Pump command state shown. Physical motor confirmation requires additional hardware feedback sensors.';

  @override
  String get irrigationPump => 'IRRIGATION PUMP';

  @override
  String get pumpIsRunning => 'PUMP IS RUNNING';

  @override
  String get pumpIsOff => 'PUMP IS OFF';

  @override
  String get turnPumpOn => 'TURN PUMP ON';

  @override
  String get turnPumpOff => 'TURN PUMP OFF';

  @override
  String get emergencyStop => '🛑 EMERGENCY STOP';

  @override
  String get todaysSummary => 'TODAY\'S SUMMARY';

  @override
  String get todaysRecommendation => 'TODAY\'S RECOMMENDATION';

  @override
  String get nextIrrigation => 'NEXT IRRIGATION';

  @override
  String get noIrrigationScheduled =>
      'No additional irrigation required today.';

  @override
  String recommendationDone(int count) {
    return 'Today\'s irrigation has been performed ($count sessions).';
  }

  @override
  String get startNow => 'START NOW';

  @override
  String get reasonNoIrrigationToday => 'Reason: No irrigation recorded today.';

  @override
  String get quickTimer => 'IRRIGATION TIMER';

  @override
  String get startTimer => 'START TIMER';

  @override
  String get stopTimer => 'STOP TIMER';

  @override
  String get setTimerDuration => 'Set Timer Duration';

  @override
  String get farmerMode => 'Farmer Mode (Simple UI)';

  @override
  String get farmerModeSubtitle =>
      'Large buttons, big text, easy for daily farm use.';

  @override
  String get appearance => 'Appearance';

  @override
  String get lightMode => 'Light';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get diagnostics => 'Watchdog & Diagnostics';

  @override
  String get completed => 'Completed';

  @override
  String get missed => 'Missed';

  @override
  String get interrupted => 'Interrupted';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get manual => 'Manual';

  @override
  String get timer => 'Timer';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get totalSessions => 'Total Sessions';

  @override
  String get pumpRuntime => 'Pump Runtime';

  @override
  String get addSchedule => 'Add Schedule';

  @override
  String get editSchedule => 'Edit Schedule';

  @override
  String get deleteSchedule => 'Delete Schedule';

  @override
  String get enable => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get startTime => 'Start Time';

  @override
  String get duration => 'Duration';

  @override
  String get repeat => 'Repeat';

  @override
  String get everyDay => 'Every Day';

  @override
  String get selectedDays => 'Selected Days';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get noSchedulesConfigured => 'No schedules configured.';

  @override
  String get irrigationScheduled => 'Irrigation scheduled';

  @override
  String get scheduleUpdated => 'Schedule updated';

  @override
  String get scheduleDeleted => 'Schedule deleted';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get noHistory => 'No irrigation history recorded yet.';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get completionRate => 'Completion Rate';

  @override
  String get totalRuntime => 'Total Runtime';

  @override
  String get bluetoothUnavailable => 'Bluetooth Unavailable';

  @override
  String get bluetoothUnavailableMsg =>
      'Bluetooth connection is unavailable. The Arduino safety watchdog will handle pump shutdown after the 2-second timeout.';

  @override
  String get emergencyStopExecuted =>
      'Emergency Stop Executed — Command \"0\" sent to Pump';

  @override
  String get notifIrrigationStartedTitle => 'Irrigation Started';

  @override
  String notifIrrigationStartedBody(int mins) {
    return 'Pump turned ON for $mins minutes.';
  }

  @override
  String get notifIrrigationCompletedTitle => 'Irrigation Completed';

  @override
  String notifIrrigationCompletedBody(int mins) {
    return 'Pump turned OFF after $mins minutes.';
  }

  @override
  String get notifConnectionLostTitle => 'Connection Lost';

  @override
  String get notifConnectionLostBody =>
      'Bluetooth disconnected while pump was ON. Arduino safety watchdog active.';

  @override
  String get weather => 'WEATHER';

  @override
  String get rainExpected => 'Rain Expected';

  @override
  String get rainProbability => 'Rain probability';

  @override
  String get weatherUnavailable => 'Weather Unavailable';

  @override
  String get considerSkipping => 'Consider Skipping Irrigation';

  @override
  String get irrigateAnyway => 'IRRIGATE ANYWAY';

  @override
  String get lastUpdated => 'Last updated';

  @override
  String get mins => 'mins';

  @override
  String get secs => 'secs';

  @override
  String get pleaseConnectFirst =>
      'Bluetooth is not connected. Tap CONNECT DEVICE above.';

  @override
  String get irrigationAlreadyRunning => 'Irrigation already running.';

  @override
  String get command1Sent => 'Command \'1\' (PUMP ON) Sent';

  @override
  String get command0Sent => 'Command \'0\' (PUMP OFF) Sent';

  @override
  String get failedToSend => 'Failed to send command.';

  @override
  String get historyScreenTitle => 'IRRIGATION HISTORY';

  @override
  String get clearHistoryTitle => 'Clear History';

  @override
  String get clearHistoryConfirm =>
      'Are you sure you want to delete all irrigation history entries?';

  @override
  String get clearAll => 'Clear All';

  @override
  String get noHistoryEntries => 'No irrigation history entries.';

  @override
  String get all => 'All';

  @override
  String get today => 'TODAY\'S ANALYTICS';

  @override
  String get yesterday => 'YESTERDAY';

  @override
  String get sessionDetails => 'Session Details';

  @override
  String get requestedDuration => 'Requested Duration:';

  @override
  String get confirmedRuntime => 'Confirmed Runtime:';

  @override
  String interruptionReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get close => 'Close';

  @override
  String get irrigationEvents => 'Irrigation Events';

  @override
  String get irrigationEventsSubtitle =>
      'Started, completed, timer notifications';

  @override
  String get connectionEvents => 'Connection Events';

  @override
  String get connectionEventsSubtitle =>
      'Bluetooth connected/disconnected alerts';

  @override
  String get safetyEvents => 'Safety & Watchdog Alerts';

  @override
  String get safetyEventsSubtitle => 'Arduino watchdog shutdown alerts';

  @override
  String get diagnosticsSubtitle => 'BLE GATT status, heartbeat & 5s pump test';

  @override
  String get aboutSubtitle => 'Bluetooth-Based Wireless Irrigation Controller';

  @override
  String get watchdogDiagnosticsTitle => 'WATCHDOG & DIAGNOSTICS';

  @override
  String get hardwareBleMetrics => 'HARDWARE & BLE METRICS';

  @override
  String get diagnosticTestSuite => 'DIAGNOSTIC TEST SUITE';

  @override
  String get testConnection => 'TEST CONNECTION';

  @override
  String get testPump5s => 'TEST PUMP FOR 5 SECONDS';

  @override
  String testingPump(int count) {
    return 'TESTING PUMP (${count}s)';
  }

  @override
  String get confirmPumpTestTitle => 'Confirm Pump Test';

  @override
  String get confirmPumpTestContent =>
      'This diagnostic will turn the pump ON for exactly 5 seconds and then automatically turn it OFF.\n\nProceed?';

  @override
  String get start5sTest => 'Start 5s Test';

  @override
  String get pumpTestCompleted => '5-Second Pump Test Completed Successfully.';

  @override
  String get discoverBluetoothDevices => 'Discover Bluetooth Devices';

  @override
  String get scanning => 'Scanning...';

  @override
  String get refreshPairedDevices => 'Refresh paired devices';

  @override
  String get btPermissionRequired => 'Bluetooth permission is required.';

  @override
  String get btPermissionDesc =>
      'Bluetooth permission is required to discover and connect to your HC-05 module.';

  @override
  String get grantPermission => 'GRANT PERMISSION';

  @override
  String connectingTo(String name, String mac) {
    return 'Connecting to $name ($mac)...';
  }

  @override
  String get scheduledIrrigationTitle => 'SCHEDULED IRRIGATION';

  @override
  String get noActiveSchedules => 'No active irrigation schedules.';

  @override
  String get scheduleName => 'Schedule Name';

  @override
  String get scheduleNameHint => 'e.g. Morning Irrigation';

  @override
  String get enableSchedule => 'Enable Schedule';

  @override
  String get saveSchedule => 'Save Schedule';

  @override
  String get durationGreaterThanZero => 'Duration must be greater than 0';

  @override
  String get irrigationInterrupted => 'Irrigation Interrupted';

  @override
  String get connectionLostTitle => 'Bluetooth connection lost.';

  @override
  String get watchdogAutoOffMsg =>
      'The Arduino safety watchdog will automatically turn the pump OFF.';

  @override
  String get lastConfirmedRuntime => 'Last confirmed runtime:';

  @override
  String get scheduledDuration => 'Scheduled duration:';

  @override
  String get pumpStateLabel => 'Pump state:';

  @override
  String get safetyShutdownPending => 'SAFETY SHUTDOWN PENDING';

  @override
  String get understand => 'Understand';

  @override
  String get customTimer => 'Custom Irrigation Timer';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'Seconds';

  @override
  String setDuration(String time) {
    return 'Set Duration: $time';
  }

  @override
  String get setTimer => 'SET TIMER';

  @override
  String timerStarted(String duration) {
    return 'Irrigation Timer Started ($duration)';
  }

  @override
  String get timerCancelled => 'Timer cancelled — Pump turned OFF.';

  @override
  String timerPresetSec(int count) {
    return '$count SEC';
  }

  @override
  String timerPresetMin(int count) {
    return '$count MIN';
  }

  @override
  String get activityLog => 'Activity Log';

  @override
  String eventsCount(int count) {
    return '$count events';
  }

  @override
  String get runtimeDisclaimer =>
      '* Confirmed/estimated runtime based on Bluetooth commands and connection timestamps, not physical sensors.';

  @override
  String get eveningIrrigation => 'Evening Irrigation';

  @override
  String get morningIrrigation => 'Morning Irrigation';

  @override
  String get afternoonIrrigation => 'Afternoon Irrigation';

  @override
  String get masterNotifications => 'Master Notifications';

  @override
  String get safetyAlerts => 'Safety Alerts';

  @override
  String get safetyAlertsSubtitle =>
      'Arduino watchdog & connection drop alerts';

  @override
  String get irrigationCompletedNotif => 'Irrigation Completed';

  @override
  String get missedIrrigationNotif => 'Missed Irrigation';

  @override
  String get upcomingReminders => 'Upcoming Reminders';

  @override
  String get dailySummaryNotif => 'Daily Summary';

  @override
  String notifPermissionStatus(String status) {
    return 'Notification Permission: $status';
  }

  @override
  String get granted => 'Granted';

  @override
  String get denied => 'Denied';

  @override
  String get openNotificationSettings => 'OPEN NOTIFICATION SETTINGS';

  @override
  String get viewHistory => 'VIEW HISTORY';

  @override
  String get viewSchedules => 'VIEW SCHEDULES';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get controllerReconnectedTitle => '📡 Controller Reconnected';

  @override
  String get controllerReconnectedBody =>
      'Smart Farm controller is connected again. Pump remains OFF for safety.';

  @override
  String get missedIrrigationTitle => '⚠️ Irrigation Missed';

  @override
  String missedIrrigationBody(String scheduleName) {
    return '$scheduleName could not start because the controller was unavailable.';
  }

  @override
  String get upcomingIrrigationTitle => '⏰ Upcoming Irrigation';

  @override
  String upcomingIrrigationBody(String scheduleName) {
    return '$scheduleName starts in 15 minutes.';
  }

  @override
  String get dailySummaryTitle => '🌱 Daily Irrigation Summary';

  @override
  String dailySummaryBody(int count, String runtime) {
    return '$count sessions completed today. Total pump runtime: $runtime.';
  }

  @override
  String get weatherRainTitle => '🌧️ Rain Expected';

  @override
  String get weatherRainBody => 'Rain expected near scheduled irrigation time.';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get gettingLocalWeather => 'Getting local weather...';

  @override
  String get locationUnavailable => 'Location Unavailable';

  @override
  String get enableLocation => 'ENABLE LOCATION';

  @override
  String get weatherDataOutdated => 'Weather data may be outdated';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String get justNow => 'just now';

  @override
  String get refresh => 'Refresh';

  @override
  String get tryAgain => 'TRY AGAIN';

  @override
  String get locationPermissionExplanation =>
      'Weather-based irrigation recommendations use your current location to retrieve local weather information.';

  @override
  String get locationPermissionDenied => 'Location permission was not granted.';

  @override
  String get locationPermissionDisabled =>
      'Location permission is disabled for Smart Farm.';

  @override
  String get farmAnalytics => 'FARM ANALYTICS';

  @override
  String get thisWeek => 'THIS WEEK';

  @override
  String get clearSky => 'Clear Sky';

  @override
  String get partlyCloudy => 'Partly Cloudy';

  @override
  String get cloudy => 'Cloudy';

  @override
  String get rainy => 'Rain';

  @override
  String get heavyRain => 'Heavy Rain';

  @override
  String get thunderstorm => 'Thunderstorm';

  @override
  String get skipOnce => 'SKIP ONCE';

  @override
  String get runNow => 'RUN NOW';

  @override
  String get recentRainfallDetected =>
      'Recent rainfall detected from local forecast.';

  @override
  String rainExpectedWarning(int percent, String time) {
    return 'Rain probability is high ($percent%) around your scheduled irrigation time ($time). Consider skipping this session.';
  }

  @override
  String get locationServicesDisabled =>
      'Device location services are disabled.';

  @override
  String get locationPermissionRequired =>
      'Location permission is required for local weather.';

  @override
  String get offlineIrrigationNotice =>
      'Your irrigation controls remain fully available offline.';

  @override
  String get openSettings => 'OPEN SETTINGS';

  @override
  String get weatherOverview => 'Weather Overview';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get evening => 'Evening';

  @override
  String get night => 'Night';

  @override
  String get todaysHigh => 'High';

  @override
  String get todaysLow => 'Low';

  @override
  String get expectedRainfall => 'Expected rain';

  @override
  String get viewFullForecast => 'VIEW FULL FORECAST';

  @override
  String get weatherDetailsTitle => 'WEATHER DETAILS';

  @override
  String get irrigationOutlook => 'Irrigation Outlook';

  @override
  String get hourlyForecast => 'Hourly Forecast';

  @override
  String get confirmSkipTitle => 'Skip Today\'s Irrigation?';

  @override
  String confirmSkipMessage(Object name, Object time) {
    return 'Skip $name ($time) for today? Future occurrences will remain active.';
  }

  @override
  String get scheduleSkippedToday => 'Irrigation skipped for today.';

  @override
  String rainExpectedWindowMsg(Object name, Object percent, Object time) {
    return 'High chance of rain ($percent%) expected around $time for $name. Consider skipping this session.';
  }

  @override
  String rainPossibleWindowMsg(Object name, Object percent, Object time) {
    return 'Rain may occur around $time for $name ($percent% chance).';
  }

  @override
  String recentRainfallMsg(Object amount) {
    return 'Recent rainfall (${amount}mm) was detected near your location. This may reduce the need for upcoming irrigation.';
  }

  @override
  String get irrigationFavorableOutlook =>
      'Morning hours appear to have a lower rain probability than evening.';

  @override
  String get staleWeatherWarning =>
      'Weather data is outdated. Refresh to get the latest recommendation.';

  @override
  String get weatherTestMode => 'WEATHER TEST MODE';

  @override
  String get demoWeatherBanner => 'DEMO WEATHER — NOT REAL FORECAST';

  @override
  String get normalWeatherTest => 'NORMAL WEATHER';

  @override
  String get rainExpectedTest => 'RAIN EXPECTED';

  @override
  String get exitTestMode => 'EXIT TEST MODE';
}
