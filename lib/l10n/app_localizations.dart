import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SMART FARM'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wireless Irrigation Controller'**
  String get appSubtitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @bluetoothConnection.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Connection'**
  String get bluetoothConnection;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @pairedModuleFound.
  ///
  /// In en, this message translates to:
  /// **'Paired module found: {deviceName} ({macAddress}). Tap Connect below.'**
  String pairedModuleFound(String deviceName, String macAddress);

  /// No description provided for @noPairedModuleFound.
  ///
  /// In en, this message translates to:
  /// **'Ensure HC-05 module is powered and paired on your Android device before connecting.'**
  String get noPairedModuleFound;

  /// No description provided for @connectDevice.
  ///
  /// In en, this message translates to:
  /// **'CONNECT DEVICE'**
  String get connectDevice;

  /// No description provided for @disconnectDevice.
  ///
  /// In en, this message translates to:
  /// **'DISCONNECT'**
  String get disconnectDevice;

  /// No description provided for @connectingButton.
  ///
  /// In en, this message translates to:
  /// **'CONNECTING...'**
  String get connectingButton;

  /// No description provided for @systemAndConnectionStatus.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM & CONNECTION STATUS'**
  String get systemAndConnectionStatus;

  /// No description provided for @bluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// No description provided for @controllerHc05.
  ///
  /// In en, this message translates to:
  /// **'Controller (HC-05)'**
  String get controllerHc05;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @gattProtocol.
  ///
  /// In en, this message translates to:
  /// **'GATT Protocol'**
  String get gattProtocol;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready (FFE0/FFE1)'**
  String get ready;

  /// No description provided for @notReady.
  ///
  /// In en, this message translates to:
  /// **'Not Ready'**
  String get notReady;

  /// No description provided for @watchdogSafety.
  ///
  /// In en, this message translates to:
  /// **'Watchdog Safety'**
  String get watchdogSafety;

  /// No description provided for @activePulse.
  ///
  /// In en, this message translates to:
  /// **'Active (500ms pulse)'**
  String get activePulse;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @pumpCommandState.
  ///
  /// In en, this message translates to:
  /// **'Pump command state:'**
  String get pumpCommandState;

  /// No description provided for @unknownDisconnected.
  ///
  /// In en, this message translates to:
  /// **'UNKNOWN (Disconnected)'**
  String get unknownDisconnected;

  /// No description provided for @onCommanded.
  ///
  /// In en, this message translates to:
  /// **'ON (Commanded)'**
  String get onCommanded;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @lastHeartbeat.
  ///
  /// In en, this message translates to:
  /// **'Last Heartbeat (\"H\"):'**
  String get lastHeartbeat;

  /// No description provided for @secAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} sec ago'**
  String secAgo(int count);

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @controllerDisconnectedWarning.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth connection lost while pump was ON. Arduino safety watchdog will turn pump OFF.'**
  String get controllerDisconnectedWarning;

  /// No description provided for @controllerConnectedWarning.
  ///
  /// In en, this message translates to:
  /// **'Controller connected via Bluetooth. Stay within reliable Bluetooth range.'**
  String get controllerConnectedWarning;

  /// No description provided for @hardwareDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'* Pump command state shown. Physical motor confirmation requires additional hardware feedback sensors.'**
  String get hardwareDisclaimer;

  /// No description provided for @irrigationPump.
  ///
  /// In en, this message translates to:
  /// **'IRRIGATION PUMP'**
  String get irrigationPump;

  /// No description provided for @pumpIsRunning.
  ///
  /// In en, this message translates to:
  /// **'PUMP IS RUNNING'**
  String get pumpIsRunning;

  /// No description provided for @pumpIsOff.
  ///
  /// In en, this message translates to:
  /// **'PUMP IS OFF'**
  String get pumpIsOff;

  /// No description provided for @turnPumpOn.
  ///
  /// In en, this message translates to:
  /// **'TURN PUMP ON'**
  String get turnPumpOn;

  /// No description provided for @turnPumpOff.
  ///
  /// In en, this message translates to:
  /// **'TURN PUMP OFF'**
  String get turnPumpOff;

  /// No description provided for @emergencyStop.
  ///
  /// In en, this message translates to:
  /// **'🛑 EMERGENCY STOP'**
  String get emergencyStop;

  /// No description provided for @todaysSummary.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S SUMMARY'**
  String get todaysSummary;

  /// No description provided for @todaysRecommendation.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S RECOMMENDATION'**
  String get todaysRecommendation;

  /// No description provided for @nextIrrigation.
  ///
  /// In en, this message translates to:
  /// **'NEXT IRRIGATION'**
  String get nextIrrigation;

  /// No description provided for @noIrrigationScheduled.
  ///
  /// In en, this message translates to:
  /// **'No additional irrigation required today.'**
  String get noIrrigationScheduled;

  /// No description provided for @recommendationDone.
  ///
  /// In en, this message translates to:
  /// **'Today\'s irrigation has been performed ({count} sessions).'**
  String recommendationDone(int count);

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'START NOW'**
  String get startNow;

  /// No description provided for @reasonNoIrrigationToday.
  ///
  /// In en, this message translates to:
  /// **'Reason: No irrigation recorded today.'**
  String get reasonNoIrrigationToday;

  /// No description provided for @quickTimer.
  ///
  /// In en, this message translates to:
  /// **'IRRIGATION TIMER'**
  String get quickTimer;

  /// No description provided for @startTimer.
  ///
  /// In en, this message translates to:
  /// **'START TIMER'**
  String get startTimer;

  /// No description provided for @stopTimer.
  ///
  /// In en, this message translates to:
  /// **'STOP TIMER'**
  String get stopTimer;

  /// No description provided for @setTimerDuration.
  ///
  /// In en, this message translates to:
  /// **'Set Timer Duration'**
  String get setTimerDuration;

  /// No description provided for @farmerMode.
  ///
  /// In en, this message translates to:
  /// **'Farmer Mode (Simple UI)'**
  String get farmerMode;

  /// No description provided for @farmerModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Large buttons, big text, easy for daily farm use.'**
  String get farmerModeSubtitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @diagnostics.
  ///
  /// In en, this message translates to:
  /// **'Watchdog & Diagnostics'**
  String get diagnostics;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @interrupted.
  ///
  /// In en, this message translates to:
  /// **'Interrupted'**
  String get interrupted;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// No description provided for @pumpRuntime.
  ///
  /// In en, this message translates to:
  /// **'Pump Runtime'**
  String get pumpRuntime;

  /// No description provided for @addSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add Schedule'**
  String get addSchedule;

  /// No description provided for @editSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit Schedule'**
  String get editSchedule;

  /// No description provided for @deleteSchedule.
  ///
  /// In en, this message translates to:
  /// **'Delete Schedule'**
  String get deleteSchedule;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every Day'**
  String get everyDay;

  /// No description provided for @selectedDays.
  ///
  /// In en, this message translates to:
  /// **'Selected Days'**
  String get selectedDays;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noSchedulesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No schedules configured.'**
  String get noSchedulesConfigured;

  /// No description provided for @irrigationScheduled.
  ///
  /// In en, this message translates to:
  /// **'Irrigation scheduled'**
  String get irrigationScheduled;

  /// No description provided for @scheduleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Schedule updated'**
  String get scheduleUpdated;

  /// No description provided for @scheduleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Schedule deleted'**
  String get scheduleDeleted;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No irrigation history recorded yet.'**
  String get noHistory;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @totalRuntime.
  ///
  /// In en, this message translates to:
  /// **'Total Runtime'**
  String get totalRuntime;

  /// No description provided for @bluetoothUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Unavailable'**
  String get bluetoothUnavailable;

  /// No description provided for @bluetoothUnavailableMsg.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth connection is unavailable. The Arduino safety watchdog will handle pump shutdown after the 2-second timeout.'**
  String get bluetoothUnavailableMsg;

  /// No description provided for @emergencyStopExecuted.
  ///
  /// In en, this message translates to:
  /// **'Emergency Stop Executed — Command \"0\" sent to Pump'**
  String get emergencyStopExecuted;

  /// No description provided for @notifIrrigationStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Started'**
  String get notifIrrigationStartedTitle;

  /// No description provided for @notifIrrigationStartedBody.
  ///
  /// In en, this message translates to:
  /// **'Pump turned ON for {mins} minutes.'**
  String notifIrrigationStartedBody(int mins);

  /// No description provided for @notifIrrigationCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Completed'**
  String get notifIrrigationCompletedTitle;

  /// No description provided for @notifIrrigationCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Pump turned OFF after {mins} minutes.'**
  String notifIrrigationCompletedBody(int mins);

  /// No description provided for @notifConnectionLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get notifConnectionLostTitle;

  /// No description provided for @notifConnectionLostBody.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth disconnected while pump was ON. Arduino safety watchdog active.'**
  String get notifConnectionLostBody;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'WEATHER'**
  String get weather;

  /// No description provided for @rainExpected.
  ///
  /// In en, this message translates to:
  /// **'Rain Expected'**
  String get rainExpected;

  /// No description provided for @rainProbability.
  ///
  /// In en, this message translates to:
  /// **'Rain probability'**
  String get rainProbability;

  /// No description provided for @weatherUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Weather Unavailable'**
  String get weatherUnavailable;

  /// No description provided for @considerSkipping.
  ///
  /// In en, this message translates to:
  /// **'Consider Skipping Irrigation'**
  String get considerSkipping;

  /// No description provided for @irrigateAnyway.
  ///
  /// In en, this message translates to:
  /// **'IRRIGATE ANYWAY'**
  String get irrigateAnyway;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get mins;

  /// No description provided for @secs.
  ///
  /// In en, this message translates to:
  /// **'secs'**
  String get secs;

  /// No description provided for @pleaseConnectFirst.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is not connected. Tap CONNECT DEVICE above.'**
  String get pleaseConnectFirst;

  /// No description provided for @irrigationAlreadyRunning.
  ///
  /// In en, this message translates to:
  /// **'Irrigation already running.'**
  String get irrigationAlreadyRunning;

  /// No description provided for @command1Sent.
  ///
  /// In en, this message translates to:
  /// **'Command \'1\' (PUMP ON) Sent'**
  String get command1Sent;

  /// No description provided for @command0Sent.
  ///
  /// In en, this message translates to:
  /// **'Command \'0\' (PUMP OFF) Sent'**
  String get command0Sent;

  /// No description provided for @failedToSend.
  ///
  /// In en, this message translates to:
  /// **'Failed to send command.'**
  String get failedToSend;

  /// No description provided for @historyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'IRRIGATION HISTORY'**
  String get historyScreenTitle;

  /// No description provided for @clearHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistoryTitle;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all irrigation history entries?'**
  String get clearHistoryConfirm;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @noHistoryEntries.
  ///
  /// In en, this message translates to:
  /// **'No irrigation history entries.'**
  String get noHistoryEntries;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S ANALYTICS'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get yesterday;

  /// No description provided for @sessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessionDetails;

  /// No description provided for @requestedDuration.
  ///
  /// In en, this message translates to:
  /// **'Requested Duration:'**
  String get requestedDuration;

  /// No description provided for @confirmedRuntime.
  ///
  /// In en, this message translates to:
  /// **'Confirmed Runtime:'**
  String get confirmedRuntime;

  /// No description provided for @interruptionReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String interruptionReason(String reason);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @irrigationEvents.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Events'**
  String get irrigationEvents;

  /// No description provided for @irrigationEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Started, completed, timer notifications'**
  String get irrigationEventsSubtitle;

  /// No description provided for @connectionEvents.
  ///
  /// In en, this message translates to:
  /// **'Connection Events'**
  String get connectionEvents;

  /// No description provided for @connectionEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth connected/disconnected alerts'**
  String get connectionEventsSubtitle;

  /// No description provided for @safetyEvents.
  ///
  /// In en, this message translates to:
  /// **'Safety & Watchdog Alerts'**
  String get safetyEvents;

  /// No description provided for @safetyEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arduino watchdog shutdown alerts'**
  String get safetyEventsSubtitle;

  /// No description provided for @diagnosticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'BLE GATT status, heartbeat & 5s pump test'**
  String get diagnosticsSubtitle;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth-Based Wireless Irrigation Controller'**
  String get aboutSubtitle;

  /// No description provided for @watchdogDiagnosticsTitle.
  ///
  /// In en, this message translates to:
  /// **'WATCHDOG & DIAGNOSTICS'**
  String get watchdogDiagnosticsTitle;

  /// No description provided for @hardwareBleMetrics.
  ///
  /// In en, this message translates to:
  /// **'HARDWARE & BLE METRICS'**
  String get hardwareBleMetrics;

  /// No description provided for @diagnosticTestSuite.
  ///
  /// In en, this message translates to:
  /// **'DIAGNOSTIC TEST SUITE'**
  String get diagnosticTestSuite;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'TEST CONNECTION'**
  String get testConnection;

  /// No description provided for @testPump5s.
  ///
  /// In en, this message translates to:
  /// **'TEST PUMP FOR 5 SECONDS'**
  String get testPump5s;

  /// No description provided for @testingPump.
  ///
  /// In en, this message translates to:
  /// **'TESTING PUMP ({count}s)'**
  String testingPump(int count);

  /// No description provided for @confirmPumpTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pump Test'**
  String get confirmPumpTestTitle;

  /// No description provided for @confirmPumpTestContent.
  ///
  /// In en, this message translates to:
  /// **'This diagnostic will turn the pump ON for exactly 5 seconds and then automatically turn it OFF.\n\nProceed?'**
  String get confirmPumpTestContent;

  /// No description provided for @start5sTest.
  ///
  /// In en, this message translates to:
  /// **'Start 5s Test'**
  String get start5sTest;

  /// No description provided for @pumpTestCompleted.
  ///
  /// In en, this message translates to:
  /// **'5-Second Pump Test Completed Successfully.'**
  String get pumpTestCompleted;

  /// No description provided for @discoverBluetoothDevices.
  ///
  /// In en, this message translates to:
  /// **'Discover Bluetooth Devices'**
  String get discoverBluetoothDevices;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @refreshPairedDevices.
  ///
  /// In en, this message translates to:
  /// **'Refresh paired devices'**
  String get refreshPairedDevices;

  /// No description provided for @btPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission is required.'**
  String get btPermissionRequired;

  /// No description provided for @btPermissionDesc.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission is required to discover and connect to your HC-05 module.'**
  String get btPermissionDesc;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'GRANT PERMISSION'**
  String get grantPermission;

  /// No description provided for @connectingTo.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {name} ({mac})...'**
  String connectingTo(String name, String mac);

  /// No description provided for @scheduledIrrigationTitle.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULED IRRIGATION'**
  String get scheduledIrrigationTitle;

  /// No description provided for @noActiveSchedules.
  ///
  /// In en, this message translates to:
  /// **'No active irrigation schedules.'**
  String get noActiveSchedules;

  /// No description provided for @scheduleName.
  ///
  /// In en, this message translates to:
  /// **'Schedule Name'**
  String get scheduleName;

  /// No description provided for @scheduleNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Morning Irrigation'**
  String get scheduleNameHint;

  /// No description provided for @enableSchedule.
  ///
  /// In en, this message translates to:
  /// **'Enable Schedule'**
  String get enableSchedule;

  /// No description provided for @saveSchedule.
  ///
  /// In en, this message translates to:
  /// **'Save Schedule'**
  String get saveSchedule;

  /// No description provided for @durationGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Duration must be greater than 0'**
  String get durationGreaterThanZero;

  /// No description provided for @irrigationInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Interrupted'**
  String get irrigationInterrupted;

  /// No description provided for @connectionLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth connection lost.'**
  String get connectionLostTitle;

  /// No description provided for @watchdogAutoOffMsg.
  ///
  /// In en, this message translates to:
  /// **'The Arduino safety watchdog will automatically turn the pump OFF.'**
  String get watchdogAutoOffMsg;

  /// No description provided for @lastConfirmedRuntime.
  ///
  /// In en, this message translates to:
  /// **'Last confirmed runtime:'**
  String get lastConfirmedRuntime;

  /// No description provided for @scheduledDuration.
  ///
  /// In en, this message translates to:
  /// **'Scheduled duration:'**
  String get scheduledDuration;

  /// No description provided for @pumpStateLabel.
  ///
  /// In en, this message translates to:
  /// **'Pump state:'**
  String get pumpStateLabel;

  /// No description provided for @safetyShutdownPending.
  ///
  /// In en, this message translates to:
  /// **'SAFETY SHUTDOWN PENDING'**
  String get safetyShutdownPending;

  /// No description provided for @understand.
  ///
  /// In en, this message translates to:
  /// **'Understand'**
  String get understand;

  /// No description provided for @customTimer.
  ///
  /// In en, this message translates to:
  /// **'Custom Irrigation Timer'**
  String get customTimer;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @setDuration.
  ///
  /// In en, this message translates to:
  /// **'Set Duration: {time}'**
  String setDuration(String time);

  /// No description provided for @setTimer.
  ///
  /// In en, this message translates to:
  /// **'SET TIMER'**
  String get setTimer;

  /// No description provided for @timerStarted.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Timer Started ({duration})'**
  String timerStarted(String duration);

  /// No description provided for @timerCancelled.
  ///
  /// In en, this message translates to:
  /// **'Timer cancelled — Pump turned OFF.'**
  String get timerCancelled;

  /// No description provided for @timerPresetSec.
  ///
  /// In en, this message translates to:
  /// **'{count} SEC'**
  String timerPresetSec(int count);

  /// No description provided for @timerPresetMin.
  ///
  /// In en, this message translates to:
  /// **'{count} MIN'**
  String timerPresetMin(int count);

  /// No description provided for @activityLog.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get activityLog;

  /// No description provided for @eventsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} events'**
  String eventsCount(int count);

  /// No description provided for @runtimeDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'* Confirmed/estimated runtime based on Bluetooth commands and connection timestamps, not physical sensors.'**
  String get runtimeDisclaimer;

  /// No description provided for @eveningIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Evening Irrigation'**
  String get eveningIrrigation;

  /// No description provided for @morningIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Morning Irrigation'**
  String get morningIrrigation;

  /// No description provided for @afternoonIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Afternoon Irrigation'**
  String get afternoonIrrigation;

  /// No description provided for @masterNotifications.
  ///
  /// In en, this message translates to:
  /// **'Master Notifications'**
  String get masterNotifications;

  /// No description provided for @safetyAlerts.
  ///
  /// In en, this message translates to:
  /// **'Safety Alerts'**
  String get safetyAlerts;

  /// No description provided for @safetyAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arduino watchdog & connection drop alerts'**
  String get safetyAlertsSubtitle;

  /// No description provided for @irrigationCompletedNotif.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Completed'**
  String get irrigationCompletedNotif;

  /// No description provided for @missedIrrigationNotif.
  ///
  /// In en, this message translates to:
  /// **'Missed Irrigation'**
  String get missedIrrigationNotif;

  /// No description provided for @upcomingReminders.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Reminders'**
  String get upcomingReminders;

  /// No description provided for @dailySummaryNotif.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get dailySummaryNotif;

  /// No description provided for @notifPermissionStatus.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission: {status}'**
  String notifPermissionStatus(String status);

  /// No description provided for @granted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get granted;

  /// No description provided for @denied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get denied;

  /// No description provided for @openNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'OPEN NOTIFICATION SETTINGS'**
  String get openNotificationSettings;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'VIEW HISTORY'**
  String get viewHistory;

  /// No description provided for @viewSchedules.
  ///
  /// In en, this message translates to:
  /// **'VIEW SCHEDULES'**
  String get viewSchedules;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @controllerReconnectedTitle.
  ///
  /// In en, this message translates to:
  /// **'📡 Controller Reconnected'**
  String get controllerReconnectedTitle;

  /// No description provided for @controllerReconnectedBody.
  ///
  /// In en, this message translates to:
  /// **'Smart Farm controller is connected again. Pump remains OFF for safety.'**
  String get controllerReconnectedBody;

  /// No description provided for @missedIrrigationTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Irrigation Missed'**
  String get missedIrrigationTitle;

  /// No description provided for @missedIrrigationBody.
  ///
  /// In en, this message translates to:
  /// **'{scheduleName} could not start because the controller was unavailable.'**
  String missedIrrigationBody(String scheduleName);

  /// No description provided for @upcomingIrrigationTitle.
  ///
  /// In en, this message translates to:
  /// **'⏰ Upcoming Irrigation'**
  String get upcomingIrrigationTitle;

  /// No description provided for @upcomingIrrigationBody.
  ///
  /// In en, this message translates to:
  /// **'{scheduleName} starts in 15 minutes.'**
  String upcomingIrrigationBody(String scheduleName);

  /// No description provided for @dailySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'🌱 Daily Irrigation Summary'**
  String get dailySummaryTitle;

  /// No description provided for @dailySummaryBody.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions completed today. Total pump runtime: {runtime}.'**
  String dailySummaryBody(int count, String runtime);

  /// No description provided for @weatherRainTitle.
  ///
  /// In en, this message translates to:
  /// **'🌧️ Rain Expected'**
  String get weatherRainTitle;

  /// No description provided for @weatherRainBody.
  ///
  /// In en, this message translates to:
  /// **'Rain expected near scheduled irrigation time.'**
  String get weatherRainBody;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @gettingLocalWeather.
  ///
  /// In en, this message translates to:
  /// **'Getting local weather...'**
  String get gettingLocalWeather;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location Unavailable'**
  String get locationUnavailable;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'ENABLE LOCATION'**
  String get enableLocation;

  /// No description provided for @weatherDataOutdated.
  ///
  /// In en, this message translates to:
  /// **'Weather data may be outdated'**
  String get weatherDataOutdated;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'TRY AGAIN'**
  String get tryAgain;

  /// No description provided for @locationPermissionExplanation.
  ///
  /// In en, this message translates to:
  /// **'Weather-based irrigation recommendations use your current location to retrieve local weather information.'**
  String get locationPermissionExplanation;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was not granted.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location permission is disabled for Smart Farm.'**
  String get locationPermissionDisabled;

  /// No description provided for @farmAnalytics.
  ///
  /// In en, this message translates to:
  /// **'FARM ANALYTICS'**
  String get farmAnalytics;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'THIS WEEK'**
  String get thisWeek;

  /// No description provided for @clearSky.
  ///
  /// In en, this message translates to:
  /// **'Clear Sky'**
  String get clearSky;

  /// No description provided for @partlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly Cloudy'**
  String get partlyCloudy;

  /// No description provided for @cloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get cloudy;

  /// No description provided for @rainy.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rainy;

  /// No description provided for @heavyRain.
  ///
  /// In en, this message translates to:
  /// **'Heavy Rain'**
  String get heavyRain;

  /// No description provided for @thunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get thunderstorm;

  /// No description provided for @skipOnce.
  ///
  /// In en, this message translates to:
  /// **'SKIP ONCE'**
  String get skipOnce;

  /// No description provided for @runNow.
  ///
  /// In en, this message translates to:
  /// **'RUN NOW'**
  String get runNow;

  /// No description provided for @recentRainfallDetected.
  ///
  /// In en, this message translates to:
  /// **'Recent rainfall detected from local forecast.'**
  String get recentRainfallDetected;

  /// No description provided for @rainExpectedWarning.
  ///
  /// In en, this message translates to:
  /// **'Rain probability is high ({percent}%) around your scheduled irrigation time ({time}). Consider skipping this session.'**
  String rainExpectedWarning(int percent, String time);

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Device location services are disabled.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required for local weather.'**
  String get locationPermissionRequired;

  /// No description provided for @offlineIrrigationNotice.
  ///
  /// In en, this message translates to:
  /// **'Your irrigation controls remain fully available offline.'**
  String get offlineIrrigationNotice;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'OPEN SETTINGS'**
  String get openSettings;

  /// No description provided for @weatherOverview.
  ///
  /// In en, this message translates to:
  /// **'Weather Overview'**
  String get weatherOverview;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @todaysHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get todaysHigh;

  /// No description provided for @todaysLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get todaysLow;

  /// No description provided for @expectedRainfall.
  ///
  /// In en, this message translates to:
  /// **'Expected rain'**
  String get expectedRainfall;

  /// No description provided for @viewFullForecast.
  ///
  /// In en, this message translates to:
  /// **'VIEW FULL FORECAST'**
  String get viewFullForecast;

  /// No description provided for @weatherDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'WEATHER DETAILS'**
  String get weatherDetailsTitle;

  /// No description provided for @irrigationOutlook.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Outlook'**
  String get irrigationOutlook;

  /// No description provided for @hourlyForecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourlyForecast;

  /// No description provided for @confirmSkipTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip Today\'s Irrigation?'**
  String get confirmSkipTitle;

  /// No description provided for @confirmSkipMessage.
  ///
  /// In en, this message translates to:
  /// **'Skip {name} ({time}) for today? Future occurrences will remain active.'**
  String confirmSkipMessage(Object name, Object time);

  /// No description provided for @scheduleSkippedToday.
  ///
  /// In en, this message translates to:
  /// **'Irrigation skipped for today.'**
  String get scheduleSkippedToday;

  /// No description provided for @rainExpectedWindowMsg.
  ///
  /// In en, this message translates to:
  /// **'High chance of rain ({percent}%) expected around {time} for {name}. Consider skipping this session.'**
  String rainExpectedWindowMsg(Object name, Object percent, Object time);

  /// No description provided for @rainPossibleWindowMsg.
  ///
  /// In en, this message translates to:
  /// **'Rain may occur around {time} for {name} ({percent}% chance).'**
  String rainPossibleWindowMsg(Object name, Object percent, Object time);

  /// No description provided for @recentRainfallMsg.
  ///
  /// In en, this message translates to:
  /// **'Recent rainfall ({amount}mm) was detected near your location. This may reduce the need for upcoming irrigation.'**
  String recentRainfallMsg(Object amount);

  /// No description provided for @irrigationFavorableOutlook.
  ///
  /// In en, this message translates to:
  /// **'Morning hours appear to have a lower rain probability than evening.'**
  String get irrigationFavorableOutlook;

  /// No description provided for @staleWeatherWarning.
  ///
  /// In en, this message translates to:
  /// **'Weather data is outdated. Refresh to get the latest recommendation.'**
  String get staleWeatherWarning;

  /// No description provided for @weatherTestMode.
  ///
  /// In en, this message translates to:
  /// **'WEATHER TEST MODE'**
  String get weatherTestMode;

  /// No description provided for @demoWeatherBanner.
  ///
  /// In en, this message translates to:
  /// **'DEMO WEATHER — NOT REAL FORECAST'**
  String get demoWeatherBanner;

  /// No description provided for @normalWeatherTest.
  ///
  /// In en, this message translates to:
  /// **'NORMAL WEATHER'**
  String get normalWeatherTest;

  /// No description provided for @rainExpectedTest.
  ///
  /// In en, this message translates to:
  /// **'RAIN EXPECTED'**
  String get rainExpectedTest;

  /// No description provided for @exitTestMode.
  ///
  /// In en, this message translates to:
  /// **'EXIT TEST MODE'**
  String get exitTestMode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
