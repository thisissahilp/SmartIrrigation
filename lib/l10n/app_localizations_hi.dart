// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'स्मार्ट फार्म';

  @override
  String get appSubtitle => 'वायरलेस सिंचाई नियंत्रक';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get schedules => 'समय-सारणी';

  @override
  String get history => 'इतिहास';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get bluetoothConnection => 'ब्लूटूथ कनेक्शन';

  @override
  String get connected => 'कनेक्ट है';

  @override
  String get connecting => 'कनेक्ट हो रहा है...';

  @override
  String get disconnected => 'डिसकनेक्ट है';

  @override
  String pairedModuleFound(String deviceName, String macAddress) {
    return 'पेयर किया गया मॉड्यूल मिला: $deviceName ($macAddress)। नीचे कनेक्ट पर टैप करें।';
  }

  @override
  String get noPairedModuleFound =>
      'कनेक्ट करने से पहले सुनिश्चित करें कि HC-05 मॉड्यूल चालू है और आपके फोन पर पेयर है।';

  @override
  String get connectDevice => 'डिवाइस कनेक्ट करें';

  @override
  String get disconnectDevice => 'डिसकनेक्ट करें';

  @override
  String get connectingButton => 'कनेक्ट हो रहा है...';

  @override
  String get systemAndConnectionStatus => 'सिस्टम और कनेक्शन स्थिति';

  @override
  String get bluetooth => 'ब्लूटूथ';

  @override
  String get controllerHc05 => 'नियंत्रक (HC-05)';

  @override
  String get available => 'उपलब्ध';

  @override
  String get unavailable => 'अनुपलब्ध';

  @override
  String get gattProtocol => 'GATT प्रोटोकॉल';

  @override
  String get ready => 'तैयार (FFE0/FFE1)';

  @override
  String get notReady => 'तैयार नहीं';

  @override
  String get watchdogSafety => 'वॉचडॉग सुरक्षा';

  @override
  String get activePulse => 'सक्रिय (500ms पल्स)';

  @override
  String get inactive => 'निष्क्रिय';

  @override
  String get pumpCommandState => 'पंप कमांड स्थिति:';

  @override
  String get unknownDisconnected => 'अज्ञात (डिसकनेक्ट)';

  @override
  String get onCommanded => 'चालू (कमांड दी गई)';

  @override
  String get off => 'बंद';

  @override
  String get lastHeartbeat => 'अंतिम हार्टबीट (\"H\"):';

  @override
  String secAgo(int count) {
    return '$count से. पहले';
  }

  @override
  String get na => 'उपलब्ध नहीं';

  @override
  String get controllerDisconnectedWarning =>
      'पंप चालू रहते ब्लूटूथ कनेक्शन टूट गया। ऑर्डिनो वॉचडॉग अपने आप पंप बंद कर देगा।';

  @override
  String get controllerConnectedWarning =>
      'नियंत्रक ब्लूटूथ से कनेक्ट है। विश्वसनीय ब्लूटूथ रेंज में रहें।';

  @override
  String get hardwareDisclaimer =>
      '* दिखाई गई स्थिति कमांड पर आधारित है। मोटर चलने की पुष्टि के लिए अतिरिक्त सेंसर आवश्यक हैं।';

  @override
  String get irrigationPump => 'सिंचाई पंप';

  @override
  String get pumpIsRunning => 'पंप चल रहा है';

  @override
  String get pumpIsOff => 'पंप बंद है';

  @override
  String get turnPumpOn => 'पंप शुरू करें';

  @override
  String get turnPumpOff => 'पंप बंद करें';

  @override
  String get emergencyStop => '🛑 आपातकालीन बंद';

  @override
  String get todaysSummary => 'आज का सिंचाई सारांश';

  @override
  String get todaysRecommendation => 'आज की सलाह';

  @override
  String get nextIrrigation => 'अगली सिंचाई';

  @override
  String get noIrrigationScheduled => 'आज और सिंचाई की आवश्यकता नहीं है।';

  @override
  String recommendationDone(int count) {
    return 'आज की सिंचाई पूरी हो गई है ($count सत्र)।';
  }

  @override
  String get startNow => 'अभी शुरू करें';

  @override
  String get reasonNoIrrigationToday => 'कारण: आज अभी तक सिंचाई नहीं हुई है।';

  @override
  String get quickTimer => 'सिंचाई टाइमर';

  @override
  String get startTimer => 'टाइमर शुरू करें';

  @override
  String get stopTimer => 'टाइमर बंद करें';

  @override
  String get setTimerDuration => 'टाइमर अवधि सेट करें';

  @override
  String get farmerMode => 'किसान मोड (सरल इंटरफ़ेस)';

  @override
  String get farmerModeSubtitle =>
      'बड़े बटन, बड़ा टेक्स्ट, दैनिक उपयोग के लिए आसान।';

  @override
  String get appearance => 'दिखावट';

  @override
  String get lightMode => 'लाइट';

  @override
  String get language => 'भाषा';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get diagnostics => 'वॉचडॉग और डायग्नोस्टिक्स';

  @override
  String get completed => 'पूरा हुआ';

  @override
  String get missed => 'छूट गया';

  @override
  String get interrupted => 'बाधित हुआ';

  @override
  String get cancelled => 'रद्द किया';

  @override
  String get manual => 'मैनुअल';

  @override
  String get timer => 'टाइमर';

  @override
  String get scheduled => 'समय-सारणी';

  @override
  String get totalSessions => 'कुल सत्र';

  @override
  String get pumpRuntime => 'पंप चलने का समय';

  @override
  String get addSchedule => 'समय-सारणी जोड़ें';

  @override
  String get editSchedule => 'समय-सारणी बदलें';

  @override
  String get deleteSchedule => 'समय-सारणी हटाएं';

  @override
  String get enable => 'सक्षम करें';

  @override
  String get disable => 'अक्षम करें';

  @override
  String get startTime => 'शुरू होने का समय';

  @override
  String get duration => 'अवधि';

  @override
  String get repeat => 'दोहराएं';

  @override
  String get everyDay => 'प्रतिदिन';

  @override
  String get selectedDays => 'चुने गए दिन';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get noSchedulesConfigured => 'कोई समय-सारणी सेट नहीं है।';

  @override
  String get irrigationScheduled => 'सिंचाई समय-सारणी सेट की गई';

  @override
  String get scheduleUpdated => 'समय-सारणी अद्यतन की गई';

  @override
  String get scheduleDeleted => 'समय-सारणी हटाई गई';

  @override
  String get monday => 'सोमवार';

  @override
  String get tuesday => 'मंगलवार';

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
  String get noHistory => 'अभी तक कोई सिंचाई इतिहास दर्ज नहीं है।';

  @override
  String get clearHistory => 'इतिहास साफ़ करें';

  @override
  String get completionRate => 'पूरा होने की दर';

  @override
  String get totalRuntime => 'कुल चलने का समय';

  @override
  String get bluetoothUnavailable => 'ब्लूटूथ अनुपलब्ध';

  @override
  String get bluetoothUnavailableMsg =>
      'ब्लूटूथ कनेक्शन उपलब्ध नहीं है। ऑर्डिनो सुरक्षा वॉचडॉग 2 सेकंड के बाद पंप अपने आप बंद कर देगा।';

  @override
  String get emergencyStopExecuted =>
      'आपातकालीन बंद किया गया — पंप बंद करने के लिए \'0\' कमांड भेजी गई';

  @override
  String get notifIrrigationStartedTitle => 'सिंचाई शुरू हुई';

  @override
  String notifIrrigationStartedBody(int mins) {
    return 'पंप $mins मिनट के लिए चालू किया गया है।';
  }

  @override
  String get notifIrrigationCompletedTitle => 'सिंचाई पूरी हुई';

  @override
  String notifIrrigationCompletedBody(int mins) {
    return '$mins मिनट के बाद पंप बंद कर दिया गया है।';
  }

  @override
  String get notifConnectionLostTitle => 'कनेक्शन टूटा';

  @override
  String get notifConnectionLostBody =>
      'पंप चालू रहते ब्लूटूथ डिसकनेक्ट हुआ। ऑर्डिनो वॉचडॉग सुरक्षा सक्रिय।';

  @override
  String get weather => 'मौसम';

  @override
  String get rainExpected => 'बारिश की संभावना';

  @override
  String get rainProbability => 'बारिश की संभावना';

  @override
  String get weatherUnavailable => 'मौसम उपलब्ध नहीं';

  @override
  String get considerSkipping => 'आज की सिंचाई छोड़ने पर विचार करें';

  @override
  String get irrigateAnyway => 'फिर भी सिंचाई करें';

  @override
  String get lastUpdated => 'अंतिम अपडेट';

  @override
  String get mins => 'मि';

  @override
  String get secs => 'से';

  @override
  String get pleaseConnectFirst =>
      'ब्लूटूथ कनेक्ट नहीं है। ऊपर \'डिवाइस कनेक्ट करें\' पर टैप करें।';

  @override
  String get irrigationAlreadyRunning => 'सिंचाई पहले से चल रही है।';

  @override
  String get command1Sent => 'कमांड \'1\' (पंप चालू) भेजी गई';

  @override
  String get command0Sent => 'कमांड \'0\' (पंप बंद) भेजी गई';

  @override
  String get failedToSend => 'कमांड भेजने में विफल।';

  @override
  String get historyScreenTitle => 'सिंचाई इतिहास';

  @override
  String get clearHistoryTitle => 'इतिहास साफ़ करें';

  @override
  String get clearHistoryConfirm =>
      'क्या आप वाकई सारा सिंचाई इतिहास हटाना चाहते हैं?';

  @override
  String get clearAll => 'सभी हटाएं';

  @override
  String get noHistoryEntries => 'कोई सिंचाई इतिहास दर्ज नहीं है।';

  @override
  String get all => 'सभी';

  @override
  String get today => 'आज का विश्लेषण';

  @override
  String get yesterday => 'कल';

  @override
  String get sessionDetails => 'सत्र विवरण';

  @override
  String get requestedDuration => 'अनुरोधित अवधि:';

  @override
  String get confirmedRuntime => 'पुष्टि की गई अवधि:';

  @override
  String interruptionReason(String reason) {
    return 'कारण: $reason';
  }

  @override
  String get close => 'बंद करें';

  @override
  String get irrigationEvents => 'सिंचाई कार्यक्रम';

  @override
  String get irrigationEventsSubtitle => 'शुरू, पूर्ण और टाइमर सूचनाएं';

  @override
  String get connectionEvents => 'कनेक्शन सूचनाएं';

  @override
  String get connectionEventsSubtitle => 'ब्लूटूथ कनेक्ट/डिसकनेक्ट अलर्ट';

  @override
  String get safetyEvents => 'सुरक्षा और वॉचडॉग अलर्ट';

  @override
  String get safetyEventsSubtitle => 'ऑर्डिनो वॉचडॉग शटडाउन अलर्ट';

  @override
  String get diagnosticsSubtitle =>
      'BLE GATT स्थिति, हार्टबीट और 5 से. पंप परीक्षण';

  @override
  String get aboutSubtitle => 'ब्लूटूथ-आधारित वायरलेस सिंचाई नियंत्रक';

  @override
  String get watchdogDiagnosticsTitle => 'वॉचडॉग और डायग्नोस्टिक्स';

  @override
  String get hardwareBleMetrics => 'हार्डवेयर और BLE मीट्रिक';

  @override
  String get diagnosticTestSuite => 'डायग्नोस्टिक परीक्षण सुइट';

  @override
  String get testConnection => 'कनेक्शन का परीक्षण करें';

  @override
  String get testPump5s => '5 सेकंड के लिए पंप परीक्षण करें';

  @override
  String testingPump(int count) {
    return 'पंप परीक्षण जारी ($countसे)';
  }

  @override
  String get confirmPumpTestTitle => 'पंप परीक्षण की पुष्टि करें';

  @override
  String get confirmPumpTestContent =>
      'यह डायग्नोस्टिक पंप को ठीक 5 सेकंड के लिए चालू करेगा और फिर स्वचालित रूप से बंद कर देगा।\n\nआगे बढ़ें?';

  @override
  String get start5sTest => '5 सेकंड परीक्षण शुरू करें';

  @override
  String get pumpTestCompleted =>
      '5-सेकंड का पंप परीक्षण सफलतापूर्वक पूरा हुआ।';

  @override
  String get discoverBluetoothDevices => 'ब्लूटूथ उपकरण खोजें';

  @override
  String get scanning => 'स्कैन कर रहा है...';

  @override
  String get refreshPairedDevices => 'पेयर किए गए उपकरणों को रीफ्रेश करें';

  @override
  String get btPermissionRequired => 'ब्लूटूथ अनुमति आवश्यक है।';

  @override
  String get btPermissionDesc =>
      'अपने HC-05 मॉड्यूल को खोजने और कनेक्ट करने के लिए ब्लूटूथ अनुमति आवश्यक है।';

  @override
  String get grantPermission => 'अनुमति दें';

  @override
  String connectingTo(String name, String mac) {
    return '$name ($mac) से कनेक्ट हो रहा है...';
  }

  @override
  String get scheduledIrrigationTitle => 'समय-सारणी सिंचाई';

  @override
  String get noActiveSchedules => 'कोई सक्रिय सिंचाई समय-सारणी नहीं है।';

  @override
  String get scheduleName => 'समय-सारणी का नाम';

  @override
  String get scheduleNameHint => 'जैसे सुबह की सिंचाई';

  @override
  String get enableSchedule => 'समय-सारणी सक्षम करें';

  @override
  String get saveSchedule => 'समय-सारणी सहेजें';

  @override
  String get durationGreaterThanZero => 'अवधि 0 से अधिक होनी चाहिए';

  @override
  String get irrigationInterrupted => 'सिंचाई बाधित हुई';

  @override
  String get connectionLostTitle => 'ब्लूटूथ कनेक्शन टूट गया।';

  @override
  String get watchdogAutoOffMsg =>
      'ऑर्डिनो सुरक्षा वॉचडॉग स्वचालित रूप से पंप बंद कर देगा।';

  @override
  String get lastConfirmedRuntime => 'अंतिम पुष्टि की गई अवधि:';

  @override
  String get scheduledDuration => 'समय-सारणी की अवधि:';

  @override
  String get pumpStateLabel => 'पंप स्थिति:';

  @override
  String get safetyShutdownPending => 'सुरक्षा शटडाउन लंबित';

  @override
  String get understand => 'समझ गया';

  @override
  String get customTimer => 'कस्टम सिंचाई टाइमर';

  @override
  String get hours => 'घंटे';

  @override
  String get minutes => 'मिनट';

  @override
  String get seconds => 'सेकंड';

  @override
  String setDuration(String time) {
    return 'अवधि सेट करें: $time';
  }

  @override
  String get setTimer => 'टाइमर सेट करें';

  @override
  String timerStarted(String duration) {
    return 'सिंचाई टाइमर शुरू हुआ ($duration)';
  }

  @override
  String get timerCancelled => 'टाइमर रद्द किया गया — पंप बंद कर दिया गया।';

  @override
  String timerPresetSec(int count) {
    return '$count सेकंड';
  }

  @override
  String timerPresetMin(int count) {
    return '$count मिनट';
  }

  @override
  String get activityLog => 'गतिविधि लॉग';

  @override
  String eventsCount(int count) {
    return '$count कार्यक्रम';
  }

  @override
  String get runtimeDisclaimer =>
      '* पुष्टि की गई अवधि ब्लूटूथ कमांड पर आधारित है, भौतिक सेंसर पर नहीं।';

  @override
  String get eveningIrrigation => 'शाम की सिंचाई';

  @override
  String get morningIrrigation => 'सुबह की सिंचाई';

  @override
  String get afternoonIrrigation => 'दोपहर की सिंचाई';

  @override
  String get masterNotifications => 'मुख्य सूचनाएं';

  @override
  String get safetyAlerts => 'सुरक्षा अलर्ट';

  @override
  String get safetyAlertsSubtitle => 'ऑर्डिनो वॉचडॉग और कनेक्शन टूटने के अलर्ट';

  @override
  String get irrigationCompletedNotif => 'सिंचाई पूर्ण सूचनाएं';

  @override
  String get missedIrrigationNotif => 'छूटी हुई सिंचाई सूचनाएं';

  @override
  String get upcomingReminders => 'आगामी सिंचाई रिमाइंडर्स';

  @override
  String get dailySummaryNotif => 'दैनिक सिंचाई सारांश';

  @override
  String notifPermissionStatus(String status) {
    return 'सूचना अनुमति: $status';
  }

  @override
  String get granted => 'अनुमति प्राप्त';

  @override
  String get denied => 'अस्वीकृत';

  @override
  String get openNotificationSettings => 'सूचना सेटिंग्स खोलें';

  @override
  String get viewHistory => 'इतिहास देखें';

  @override
  String get viewSchedules => 'समय-सारणी देखें';

  @override
  String get dismiss => 'हटाएं';

  @override
  String get controllerReconnectedTitle => '📡 नियंत्रक पुनः कनेक्ट हुआ';

  @override
  String get controllerReconnectedBody =>
      'स्मार्ट फार्म नियंत्रक पुनः कनेक्ट हो गया है। सुरक्षा के लिए पंप बंद है।';

  @override
  String get missedIrrigationTitle => '⚠️ सिंचाई छूट गई';

  @override
  String missedIrrigationBody(String scheduleName) {
    return 'नियंत्रक उपलब्ध न होने के कारण $scheduleName शुरू नहीं हो सका।';
  }

  @override
  String get upcomingIrrigationTitle => '⏰ आगामी सिंचाई रिमाइंडर';

  @override
  String upcomingIrrigationBody(String scheduleName) {
    return '$scheduleName 15 मिनट में शुरू होगा।';
  }

  @override
  String get dailySummaryTitle => '🌱 दैनिक सिंचाई सारांश';

  @override
  String dailySummaryBody(int count, String runtime) {
    return 'आज $count सत्र पूरे हुए। कुल पंप चलने का समय: $runtime।';
  }

  @override
  String get weatherRainTitle => '🌧️ बारिश की संभावना';

  @override
  String get weatherRainBody => 'सिंचाई के समय के आसपास बारिश की संभावना है।';

  @override
  String get currentLocation => 'वर्तमान स्थान';

  @override
  String get gettingLocalWeather => 'स्थानीय मौसम प्राप्त किया जा रहा है...';

  @override
  String get locationUnavailable => 'स्थान उपलब्ध नहीं';

  @override
  String get enableLocation => 'स्थान सक्षम करें';

  @override
  String get weatherDataOutdated => 'मौसम डेटा पुराना हो सकता है';

  @override
  String minutesAgo(int count) {
    return '$count मि पहले';
  }

  @override
  String get justNow => 'अभी';

  @override
  String get refresh => 'ताज़ा करें';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get locationPermissionExplanation =>
      'मौसम-आधारित सिंचाई सिफारिशें स्थानीय मौसम जानकारी प्राप्त करने के लिए आपके वर्तमान स्थान का उपयोग करती हैं।';

  @override
  String get locationPermissionDenied => 'स्थान अनुमति नहीं दी गई।';

  @override
  String get locationPermissionDisabled =>
      'स्मार्ट फार्म के लिए स्थान अनुमति अक्षम है।';

  @override
  String get farmAnalytics => 'फार्म विश्लेषण';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get clearSky => 'साफ आसमान';

  @override
  String get partlyCloudy => 'आंशिक रूप से बादल';

  @override
  String get cloudy => 'बादल छाए हैं';

  @override
  String get rainy => 'बारिश';

  @override
  String get heavyRain => 'भारी बारिश';

  @override
  String get thunderstorm => 'आंधी-तूफान';

  @override
  String get skipOnce => 'एक बार छोड़ें';

  @override
  String get runNow => 'अभी चालू करें';

  @override
  String get recentRainfallDetected =>
      'स्थानीय पूर्वानुमान से हाल ही में बारिश का पता चला है।';

  @override
  String rainExpectedWarning(int percent, String time) {
    return 'आपकी निर्धारित सिंचाई के समय ($time) के आसपास बारिश की संभावना अधिक ($percent%) है। इस सत्र को छोड़ने पर विचार करें।';
  }

  @override
  String get locationServicesDisabled => 'डिवाइस स्थान सेवाएं अक्षम हैं।';

  @override
  String get locationPermissionRequired =>
      'स्थानीय मौसम की जानकारी प्राप्त करने के लिए स्थान की अनुमति आवश्यक है।';

  @override
  String get offlineIrrigationNotice =>
      'आपके सिंचाई नियंत्रण ऑफलाइन भी उपलब्ध हैं।';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get weatherOverview => 'मौसम विवरण';

  @override
  String get morning => 'सुबह';

  @override
  String get afternoon => 'दोपहर';

  @override
  String get evening => 'शाम';

  @override
  String get night => 'रात';

  @override
  String get todaysHigh => 'अधिकतम';

  @override
  String get todaysLow => 'न्यूनतम';

  @override
  String get expectedRainfall => 'अपेक्षित बारिश';

  @override
  String get viewFullForecast => 'पूरा पूर्वानुमान देखें';

  @override
  String get weatherDetailsTitle => 'मौसम विवरण';

  @override
  String get irrigationOutlook => 'सिंचाई दृष्टिकोण';

  @override
  String get hourlyForecast => 'प्रति घंटा पूर्वानुमान';

  @override
  String get confirmSkipTitle => 'आज की सिंचाई छोड़ें?';

  @override
  String confirmSkipMessage(Object name, Object time) {
    return 'क्या आज के लिए $name ($time) छोड़ना चाहते हैं? भविष्य के शेड्यूल सक्रिय रहेंगे।';
  }

  @override
  String get scheduleSkippedToday => 'आज की सिंचाई छोड़ दी गई है।';

  @override
  String rainExpectedWindowMsg(Object name, Object percent, Object time) {
    return '$name के लिए $time के आसपास बारिश की उच्च संभावना ($percent%) है। इस सत्र को छोड़ने पर विचार करें।';
  }

  @override
  String rainPossibleWindowMsg(Object name, Object percent, Object time) {
    return '$name के लिए $time के आसपास बारिश हो सकती है ($percent% संभावना)।';
  }

  @override
  String recentRainfallMsg(Object amount) {
    return 'आपके स्थान के पास हाल ही में बारिश ($amountमिमी) दर्ज की गई है। इससे आगामी सिंचाई की आवश्यकता कम हो सकती है।';
  }

  @override
  String get irrigationFavorableOutlook =>
      'शाम की तुलना में सुबह के समय बारिश की संभावना कम प्रतीत होती है।';

  @override
  String get staleWeatherWarning =>
      'मौसम डेटा पुराना है। नवीनतम सिफारिश के लिए ताज़ा करें।';

  @override
  String get weatherTestMode => 'मौसम परीक्षण मोड';

  @override
  String get demoWeatherBanner => 'डेमो मौसम — वास्तविक पूर्वानुमान नहीं';

  @override
  String get normalWeatherTest => 'सामान्य मौसम';

  @override
  String get rainExpectedTest => 'बारिश की संभावना';

  @override
  String get exitTestMode => 'परीक्षण मोड से बाहर निकलें';
}
