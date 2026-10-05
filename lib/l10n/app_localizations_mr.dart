// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'स्मार्ट फार्म';

  @override
  String get appSubtitle => 'वायरलेस सिंचन नियंत्रक';

  @override
  String get dashboard => 'डॅशबोर्ड';

  @override
  String get schedules => 'वेळापत्रक';

  @override
  String get history => 'इतिहास';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get bluetoothConnection => 'ब्लूटूथ कनेक्शन';

  @override
  String get connected => 'जोडले गेले';

  @override
  String get connecting => 'जोडत आहे...';

  @override
  String get disconnected => 'डिसकनेक्ट झाले';

  @override
  String pairedModuleFound(String deviceName, String macAddress) {
    return 'पेअर केलेले मॉड्युल सापडले: $deviceName ($macAddress). खालील जोडा वर टॅप करा.';
  }

  @override
  String get noPairedModuleFound =>
      'जोडण्यापूर्वी HC-05 मॉड्युल सुरू आहे आणि आपल्या फोनवर पेअर आहे याची खात्री करा.';

  @override
  String get connectDevice => 'डिव्हाइस जोडा';

  @override
  String get disconnectDevice => 'डिसकनेक्ट करा';

  @override
  String get connectingButton => 'जोडत आहे...';

  @override
  String get systemAndConnectionStatus => 'सिस्टम आणि कनेक्शन स्थिती';

  @override
  String get bluetooth => 'ब्लूटूथ';

  @override
  String get controllerHc05 => 'कंट्रोलर (HC-05)';

  @override
  String get available => 'उपलब्ध';

  @override
  String get unavailable => 'अनुपलब्ध';

  @override
  String get gattProtocol => 'GATT प्रोटोकॉल';

  @override
  String get ready => 'तयार (FFE0/FFE1)';

  @override
  String get notReady => 'तयार नाही';

  @override
  String get watchdogSafety => 'वॉचडॉग सुरक्षा';

  @override
  String get activePulse => 'सक्रिय (५००ms पल्स)';

  @override
  String get inactive => 'निष्क्रिय';

  @override
  String get pumpCommandState => 'पंप कमांड स्थिती:';

  @override
  String get unknownDisconnected => 'अज्ञात (डिसकनेक्ट)';

  @override
  String get onCommanded => 'चालू (कमांड दिली)';

  @override
  String get off => 'बंद';

  @override
  String get lastHeartbeat => 'शेवटचे हार्टबीट (\"H\"):';

  @override
  String secAgo(int count) {
    return '$count से. पूर्वी';
  }

  @override
  String get na => 'उपलब्ध नाही';

  @override
  String get controllerDisconnectedWarning =>
      'पंप सुरू असताना ब्लूटूथ कनेक्शन तुटले. आर्दुइनो वॉचडॉग आपोआप पंप बंद करेल.';

  @override
  String get controllerConnectedWarning =>
      'कंट्रोलर ब्लूटूथने जोडला आहे. चांगल्या ब्लूटूथ रेंजमध्ये राहा.';

  @override
  String get hardwareDisclaimer =>
      '* दाखवलेली स्थिती कमांडनुसार आहे. मोटर प्रत्यक्ष सुरू असल्याची खात्री करण्यासाठी अतिरिक्त सेन्सर आवश्यक आहेत.';

  @override
  String get irrigationPump => 'सिंचन पंप';

  @override
  String get pumpIsRunning => 'पंप चालू आहे';

  @override
  String get pumpIsOff => 'पंप बंद आहे';

  @override
  String get turnPumpOn => 'पंप सुरू करा';

  @override
  String get turnPumpOff => 'पंप बंद करा';

  @override
  String get emergencyStop => '🛑 आपत्कालीन बंद';

  @override
  String get todaysSummary => 'आजचा सिंचन सारांश';

  @override
  String get todaysRecommendation => 'आजची शिफारस';

  @override
  String get nextIrrigation => 'पुढील सिंचन';

  @override
  String get noIrrigationScheduled => 'आज आणखी सिंचनाची गरज नाही.';

  @override
  String recommendationDone(int count) {
    return 'आजचे सिंचन पूर्ण झाले आहे ($count सत्रे).';
  }

  @override
  String get startNow => 'आता सुरू करा';

  @override
  String get reasonNoIrrigationToday => 'कारण: आज अद्याप सिंचन झालेले नाही.';

  @override
  String get quickTimer => 'सिंचन टायमर';

  @override
  String get startTimer => 'टायमर सुरू करा';

  @override
  String get stopTimer => 'टायमर बंद करा';

  @override
  String get setTimerDuration => 'टायमर वेळ निवडा';

  @override
  String get farmerMode => 'शेतकरी मोड (सोपा इंटरफेस)';

  @override
  String get farmerModeSubtitle =>
      'मोठी बटणे, मोठा मजकूर, रोजच्या वापरासाठी सोपे.';

  @override
  String get appearance => 'देखावा';

  @override
  String get lightMode => 'लाइट';

  @override
  String get language => 'भाषा';

  @override
  String get notifications => 'सूचना';

  @override
  String get diagnostics => 'वॉचडॉग आणि डायग्नोस्टिक्स';

  @override
  String get completed => 'पूर्ण झाले';

  @override
  String get missed => 'चुकीले';

  @override
  String get interrupted => 'खंडित झाले';

  @override
  String get cancelled => 'रद्द केले';

  @override
  String get manual => 'मॅन्युअल';

  @override
  String get timer => 'टायमर';

  @override
  String get scheduled => 'वेळापत्रकानुसार';

  @override
  String get totalSessions => 'एकूण सत्रे';

  @override
  String get pumpRuntime => 'पंप चालण्याची वेळ';

  @override
  String get addSchedule => 'वेळापत्रक जोडा';

  @override
  String get editSchedule => 'वेळापत्रक बदला';

  @override
  String get deleteSchedule => 'वेळापत्रक मिटवा';

  @override
  String get enable => 'सुरू करा';

  @override
  String get disable => 'बंद करा';

  @override
  String get startTime => 'सुरू होण्याची वेळ';

  @override
  String get duration => 'कालावधी';

  @override
  String get repeat => 'पुनरावृत्ती';

  @override
  String get everyDay => 'दररोज';

  @override
  String get selectedDays => 'निवडलेले दिवस';

  @override
  String get save => 'जतन करा';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get delete => 'मिटवा';

  @override
  String get noSchedulesConfigured => 'कोणतेही वेळापत्रक सेट केलेले नाही.';

  @override
  String get irrigationScheduled => 'सिंचन वेळापत्रक सेट केले';

  @override
  String get scheduleUpdated => 'वेळापत्रक अद्यतनित केले';

  @override
  String get scheduleDeleted => 'वेळापत्रक मिटवले';

  @override
  String get monday => 'सोमवार';

  @override
  String get tuesday => 'मंगळवार';

  @override
  String get wednesday => 'बुधवार';

  @override
  String get thursday => 'गुरुवार';

  @override
  String get friday => 'शुक्रवार';

  @override
  String get saturday => 'शनिवार';

  @override
  String get sunday => 'रविवार';

  @override
  String get noHistory => 'अद्याप कोणतीही सिंचन नोंद नाही.';

  @override
  String get clearHistory => 'इतिहास साफ करा';

  @override
  String get completionRate => 'पूर्ण होण्याचे प्रमाण';

  @override
  String get totalRuntime => 'एकूण चाललेली वेळ';

  @override
  String get bluetoothUnavailable => 'ब्लूटूथ उपलब्ध नाही';

  @override
  String get bluetoothUnavailableMsg =>
      'ब्लूटूथ कनेक्शन उपलब्ध नाही. आर्दुइनो सुरक्षा वॉचडॉग २ सेकंदांनंतर पंप आपोआप बंद करेल.';

  @override
  String get emergencyStopExecuted =>
      'आपत्कालीन बंद केले — पंप बंद करण्यासाठी \'0\' कमांड पाठवली';

  @override
  String get notifIrrigationStartedTitle => 'सिंचन सुरू झाले';

  @override
  String notifIrrigationStartedBody(int mins) {
    return 'पंप $mins मिनिटांसाठी सुरू झाला आहे.';
  }

  @override
  String get notifIrrigationCompletedTitle => 'सिंचन पूर्ण झाले';

  @override
  String notifIrrigationCompletedBody(int mins) {
    return '$mins मिनिटांनंतर पंप बंद झाला आहे.';
  }

  @override
  String get notifConnectionLostTitle => 'कनेक्शन तुटले';

  @override
  String get notifConnectionLostBody =>
      'पंप सुरू असताना ब्लूटूथ डिसकनेक्ट झाले. आर्दुइनो वॉचडॉग सुरक्षा सक्रिय.';

  @override
  String get weather => 'हवामान';

  @override
  String get rainExpected => 'पावसाची शक्यता';

  @override
  String get rainProbability => 'पावसाची शक्यता';

  @override
  String get weatherUnavailable => 'हवामान उपलब्ध नाही';

  @override
  String get considerSkipping => 'आजचे सिंचन रद्द करण्याचा विचार करा';

  @override
  String get irrigateAnyway => 'तरीही सिंचन करा';

  @override
  String get lastUpdated => 'शेवटचे अपडेट';

  @override
  String get mins => 'मि';

  @override
  String get secs => 'से';

  @override
  String get pleaseConnectFirst =>
      'ब्लूटूथ जोडलेले नाही. वर \'डिव्हाइस जोडा\' वर टॅप करा.';

  @override
  String get irrigationAlreadyRunning => 'सिंचन आधीच सुरू आहे.';

  @override
  String get command1Sent => 'कमांड \'1\' (पंप सुरू) पाठवली';

  @override
  String get command0Sent => 'कमांड \'0\' (पंप बंद) पाठवली';

  @override
  String get failedToSend => 'कमांड पाठवणे अयशस्वी.';

  @override
  String get historyScreenTitle => 'सिंचन इतिहास';

  @override
  String get clearHistoryTitle => 'इतिहास साफ करा';

  @override
  String get clearHistoryConfirm =>
      'तुम्हाला खरोखर सर्व सिंचन इतिहास मिटवायचा आहे का?';

  @override
  String get clearAll => 'सर्व मिटवा';

  @override
  String get noHistoryEntries => 'कोणतीही सिंचन नोंद नाही.';

  @override
  String get all => 'सर्व';

  @override
  String get today => 'आजचे विश्लेषण';

  @override
  String get yesterday => 'काल';

  @override
  String get sessionDetails => 'सत्र तपशील';

  @override
  String get requestedDuration => 'मागणी केलेला कालावधी:';

  @override
  String get confirmedRuntime => 'पुष्टी केलेला वेळ:';

  @override
  String interruptionReason(String reason) {
    return 'कारण: $reason';
  }

  @override
  String get close => 'बंद करा';

  @override
  String get irrigationEvents => 'सिंचन घडामोडी';

  @override
  String get irrigationEventsSubtitle => 'सुरू, पूर्ण आणि टायमर सूचना';

  @override
  String get connectionEvents => 'कनेक्शन घडामोडी';

  @override
  String get connectionEventsSubtitle => 'ब्लूटूथ कनेक्ट/डिसकनेक्ट सूचना';

  @override
  String get safetyEvents => 'सुरक्षा आणि वॉचडॉग सूचना';

  @override
  String get safetyEventsSubtitle => 'आर्दुइनो वॉचडॉग बंद सूचना';

  @override
  String get diagnosticsSubtitle =>
      'BLE GATT स्थिती, हार्टबीट आणि ५ से. पंप चाचणी';

  @override
  String get aboutSubtitle => 'ब्लूटूथ-आधारित वायरलेस सिंचन नियंत्रक';

  @override
  String get watchdogDiagnosticsTitle => 'वॉचडॉग आणि डायग्नोस्टिक्स';

  @override
  String get hardwareBleMetrics => 'हार्डवेअर आणि BLE माहिती';

  @override
  String get diagnosticTestSuite => 'डायग्नोस्टिक चाचणी संच';

  @override
  String get testConnection => 'कनेक्शन चाचणी घ्या';

  @override
  String get testPump5s => '५ सेकंद पंप चाचणी करा';

  @override
  String testingPump(int count) {
    return 'पंप चाचणी चालू ($countसे)';
  }

  @override
  String get confirmPumpTestTitle => 'पंप चाचणीची पुष्टी करा';

  @override
  String get confirmPumpTestContent =>
      'हे डायग्नोस्टिक पंप नेमका ५ सेकंदांसाठी सुरू करेल आणि नंतर आपोआप बंद करेल.\n\nपुढे जायचे?';

  @override
  String get start5sTest => '५ सेकंद चाचणी सुरू करा';

  @override
  String get pumpTestCompleted =>
      '५-सेकंदांची पंप चाचणी यशस्वीरीत्या पूर्ण झाली.';

  @override
  String get discoverBluetoothDevices => 'ब्लूटूथ उपकरणे शोधा';

  @override
  String get scanning => 'शोधत आहे...';

  @override
  String get refreshPairedDevices => 'पेअर केलेली उपकरणे रीफ्रेश करा';

  @override
  String get btPermissionRequired => 'ब्लूटूथ परवानगी आवश्यक आहे.';

  @override
  String get btPermissionDesc =>
      'तुमच्या HC-05 मॉड्युलचा शोध घेण्यासाठी आणि जोडण्यासाठी ब्लूटूथ परवानगी आवश्यक आहे.';

  @override
  String get grantPermission => 'परवानगी द्या';

  @override
  String connectingTo(String name, String mac) {
    return '$name ($mac) शी जोडत आहे...';
  }

  @override
  String get scheduledIrrigationTitle => 'वेळापत्रकानुसार सिंचन';

  @override
  String get noActiveSchedules => 'कोणतेही सक्रिय सिंचन वेळापत्रक नाही.';

  @override
  String get scheduleName => 'वेळापत्रकाचे नाव';

  @override
  String get scheduleNameHint => 'उदा. सकाळचे सिंचन';

  @override
  String get enableSchedule => 'वेळापत्रक सुरू करा';

  @override
  String get saveSchedule => 'वेळापत्रक जतन करा';

  @override
  String get durationGreaterThanZero => 'कालावधी ० पेक्षा जास्त असावा';

  @override
  String get irrigationInterrupted => 'सिंचन खंडित झाले';

  @override
  String get connectionLostTitle => 'ब्लूटूथ कनेक्शन खंडित झाले.';

  @override
  String get watchdogAutoOffMsg =>
      'आर्दुइनो सुरक्षा वॉचडॉग आपोआप पंप बंद करेल.';

  @override
  String get lastConfirmedRuntime => 'शेवटची पुष्टी झालेली वेळ:';

  @override
  String get scheduledDuration => 'वेळापत्रकाचा कालावधी:';

  @override
  String get pumpStateLabel => 'पंप स्थिती:';

  @override
  String get safetyShutdownPending => 'सुरक्षा बंद प्रक्रिया सुरू';

  @override
  String get understand => 'समजले';

  @override
  String get customTimer => 'कस्टम सिंचन टायमर';

  @override
  String get hours => 'तास';

  @override
  String get minutes => 'मिनिटे';

  @override
  String get seconds => 'सेकंद';

  @override
  String setDuration(String time) {
    return 'कालावधी निश्चित करा: $time';
  }

  @override
  String get setTimer => 'टायमर लावा';

  @override
  String timerStarted(String duration) {
    return 'सिंचन टायमर सुरू झाला ($duration)';
  }

  @override
  String get timerCancelled => 'टायमर रद्द केला — पंप बंद झाला.';

  @override
  String timerPresetSec(int count) {
    return '$count सेकंद';
  }

  @override
  String timerPresetMin(int count) {
    return '$count मिनिटे';
  }

  @override
  String get activityLog => 'कृती नोंद';

  @override
  String eventsCount(int count) {
    return '$count नोंदी';
  }

  @override
  String get runtimeDisclaimer =>
      '* पुष्टी केलेला कालावधी ब्लूटूथ कमांड्सवर आधारित आहे, प्रत्यक्ष सेन्सरवर नाही.';

  @override
  String get eveningIrrigation => 'संध्याकाळचे सिंचन';

  @override
  String get morningIrrigation => 'सकाळचे सिंचन';

  @override
  String get afternoonIrrigation => 'दुपारचे सिंचन';

  @override
  String get masterNotifications => 'मुख्य सूचना';

  @override
  String get safetyAlerts => 'सुरक्षा सूचना';

  @override
  String get safetyAlertsSubtitle =>
      'आर्दुइनो वॉचडॉग व कनेक्शन तुटण्याच्या सूचना';

  @override
  String get irrigationCompletedNotif => 'सिंचन पूर्ण सूचना';

  @override
  String get missedIrrigationNotif => 'हुकलेले सिंचन सूचना';

  @override
  String get upcomingReminders => 'पुढील सिंचन स्मरणपत्रे';

  @override
  String get dailySummaryNotif => 'दैनिक सिंचन सारांश';

  @override
  String notifPermissionStatus(String status) {
    return 'सूचना परवानगी: $status';
  }

  @override
  String get granted => 'दिली आहे';

  @override
  String get denied => 'नाकारली';

  @override
  String get openNotificationSettings => 'सूचना सेटिंग्ज उघडा';

  @override
  String get viewHistory => 'इतिहास पहा';

  @override
  String get viewSchedules => 'वेळापत्रक पहा';

  @override
  String get dismiss => 'बंद करा';

  @override
  String get controllerReconnectedTitle => '📡 कंट्रोलर पुन्हा जोडला';

  @override
  String get controllerReconnectedBody =>
      'स्मार्ट फार्म कंट्रोलर पुन्हा जोडला गेला आहे. सुरक्षेसाठी पंप बंद आहे.';

  @override
  String get missedIrrigationTitle => '⚠️ सिंचन हुकले';

  @override
  String missedIrrigationBody(String scheduleName) {
    return 'कंट्रोलर उपलब्ध नसल्याने $scheduleName सुरू होऊ शकले नाही.';
  }

  @override
  String get upcomingIrrigationTitle => '⏰ पुढील सिंचन स्मरणपत्र';

  @override
  String upcomingIrrigationBody(String scheduleName) {
    return '$scheduleName १५ मिनिटांत सुरू होईल.';
  }

  @override
  String get dailySummaryTitle => '🌱 दैनिक सिंचन सारांश';

  @override
  String dailySummaryBody(int count, String runtime) {
    return 'आज $count सत्रे पूर्ण झाली. एकूण पंप चाललेली वेळ: $runtime.';
  }

  @override
  String get weatherRainTitle => '🌧️ पावसाची शक्यता';

  @override
  String get weatherRainBody => 'सिंचनाच्या वेळेजवळ पावसाची शक्यता आहे.';

  @override
  String get currentLocation => 'सध्याचे स्थान';

  @override
  String get gettingLocalWeather => 'स्थानिक हवामान मिळवत आहे...';

  @override
  String get locationUnavailable => 'स्थान उपलब्ध नाही';

  @override
  String get enableLocation => 'स्थान सक्षम करा';

  @override
  String get weatherDataOutdated => 'हवामान डेटा जुना असू शकतो';

  @override
  String minutesAgo(int count) {
    return '$count मि पूर्वी';
  }

  @override
  String get justNow => 'आत्ताच';

  @override
  String get refresh => 'रिफ्रेश करा';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get locationPermissionExplanation =>
      'हवामान-आधारित सिंचन शिफारशी स्थानिक हवामान माहिती मिळवण्यासाठी तुमचे सध्याचे स्थान वापरतात.';

  @override
  String get locationPermissionDenied => 'स्थान परवानगी दिली नाही.';

  @override
  String get locationPermissionDisabled =>
      'स्मार्ट फार्मसाठी स्थान परवानगी अक्षम केली आहे.';

  @override
  String get farmAnalytics => 'फार्म विश्लेषण';

  @override
  String get thisWeek => 'या आठवड्यात';

  @override
  String get clearSky => 'निरभ्र आकाश';

  @override
  String get partlyCloudy => 'भागशः ढगाळ';

  @override
  String get cloudy => 'ढगाळ';

  @override
  String get rainy => 'पाऊस';

  @override
  String get heavyRain => 'मुसळधार पाऊस';

  @override
  String get thunderstorm => 'वादळी पाऊस';

  @override
  String get skipOnce => 'एकदा गमवा';

  @override
  String get runNow => 'आत्ता सुरू करा';

  @override
  String get recentRainfallDetected =>
      'स्थानिक अंदाजावरून नुकताच पाऊस पडल्याचे आढळले आहे.';

  @override
  String rainExpectedWarning(int percent, String time) {
    return 'तुमच्या नियोजनबद्ध सिंचनाच्या वेळी ($time) पावसाची शक्यता जास्त ($percent%) आहे. हे सत्र वगळण्याचा विचार करा.';
  }

  @override
  String get locationServicesDisabled =>
      'डिव्हाइसची स्थान सेवा अक्षम केली आहे.';

  @override
  String get locationPermissionRequired =>
      'स्थानिक हवामानाची माहिती मिळवण्यासाठी स्थानाची परवानगी आवश्यक आहे.';

  @override
  String get offlineIrrigationNotice =>
      'तुमची सिंचन नियंत्रणे ऑफलाइन देखील उपलब्ध आहेत.';

  @override
  String get openSettings => 'सेटिंग्ज उघडा';

  @override
  String get weatherOverview => 'हवामान सारांश';

  @override
  String get morning => 'सकाळ';

  @override
  String get afternoon => 'दुपार';

  @override
  String get evening => 'संध्याकाळ';

  @override
  String get night => 'रात्र';

  @override
  String get todaysHigh => 'उच्च';

  @override
  String get todaysLow => 'कमी';

  @override
  String get expectedRainfall => 'अपेक्षित पाऊस';

  @override
  String get viewFullForecast => 'संपूर्ण अंदाज पहा';

  @override
  String get weatherDetailsTitle => 'हवामान तपशील';

  @override
  String get irrigationOutlook => 'सिंचन दृष्टीकोन';

  @override
  String get hourlyForecast => 'ताशी अंदाज';

  @override
  String get confirmSkipTitle => 'आजचे सिंचन वगळायचे?';

  @override
  String confirmSkipMessage(Object name, Object time) {
    return 'आजसाठी $name ($time) वगळायचे का? भविष्यातील वेळापत्रक सक्रिय राहील.';
  }

  @override
  String get scheduleSkippedToday => 'आजचे सिंचन वगळले आहे.';

  @override
  String rainExpectedWindowMsg(Object name, Object percent, Object time) {
    return '$name साठी $time च्या सुमारास पावसाची जास्त शक्यता ($percent%) आहे. हे सत्र वगळण्याचा विचार करा.';
  }

  @override
  String rainPossibleWindowMsg(Object name, Object percent, Object time) {
    return '$name साठी $time च्या सुमारास पाऊस पडू शकतो ($percent% शक्यता).';
  }

  @override
  String recentRainfallMsg(Object amount) {
    return 'तुमच्या स्थानाजवळ नुकताच पाऊस ($amountमिमी) आढळला आहे. यामुळे आगामी सिंचनाची गरज कमी होऊ शकते.';
  }

  @override
  String get irrigationFavorableOutlook =>
      'संध्याकाळपेक्षा सकाळच्या वेळी पावसाची शक्यता कमी दिसते.';

  @override
  String get staleWeatherWarning =>
      'हवामान डेटा जुना आहे. नवीन शिफारशीसाठी रिफ्रेश करा.';

  @override
  String get weatherTestMode => 'हवामान चाचणी मोड';

  @override
  String get demoWeatherBanner => 'डेमो हवामान — वास्तववादी अंदाज नाही';

  @override
  String get normalWeatherTest => 'सामान्य हवामान';

  @override
  String get rainExpectedTest => 'पावसाची शक्यता';

  @override
  String get exitTestMode => 'चाचणी मोडमधून बाहेर पडा';
}
