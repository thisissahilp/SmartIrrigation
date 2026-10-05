enum AppLanguage {
  english,
  marathi,
  hindi;

  String get displayName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.marathi:
        return 'मराठी (Marathi)';
      case AppLanguage.hindi:
        return 'हिन्दी (Hindi)';
    }
  }
}

class AppTranslations {
  static const Map<String, Map<AppLanguage, String>> _localizedValues = {
    'appTitle': {
      AppLanguage.english: 'SMART FARM',
      AppLanguage.marathi: 'स्मार्ट फार्म',
      AppLanguage.hindi: 'स्मार्ट फार्म',
    },
    'appSubtitle': {
      AppLanguage.english: 'Wireless Irrigation Controller',
      AppLanguage.marathi: 'वायरलेस सिंचन नियंत्रक',
      AppLanguage.hindi: 'वायरलेस सिंचाई नियंत्रक',
    },
    'dashboard': {
      AppLanguage.english: 'Dashboard',
      AppLanguage.marathi: 'डॅशबोर्ड',
      AppLanguage.hindi: 'डैशबोर्ड',
    },
    'schedules': {
      AppLanguage.english: 'Schedules',
      AppLanguage.marathi: 'वेळापत्रक',
      AppLanguage.hindi: 'समय सारणी',
    },
    'history': {
      AppLanguage.english: 'History',
      AppLanguage.marathi: 'इतिहास',
      AppLanguage.hindi: 'इतिहास',
    },
    'settings': {
      AppLanguage.english: 'Settings',
      AppLanguage.marathi: 'सेटिंग्ज',
      AppLanguage.hindi: 'सेटिंग्स',
    },
    'controllerConnected': {
      AppLanguage.english: 'Controller Connected',
      AppLanguage.marathi: 'कंट्रोलर कनेक्ट झाले',
      AppLanguage.hindi: 'नियंत्रक कनेक्टेड',
    },
    'controllerDisconnected': {
      AppLanguage.english: 'Controller Disconnected',
      AppLanguage.marathi: 'कंट्रोलर डिस्कनेक्ट झाले',
      AppLanguage.hindi: 'नियंत्रक डिस्कनेक्टेड',
    },
    'pumpOn': {
      AppLanguage.english: '🟢 PUMP ON',
      AppLanguage.marathi: '🟢 पंप सुरू',
      AppLanguage.hindi: '🟢 पंप चालू',
    },
    'pumpOff': {
      AppLanguage.english: '⚪ PUMP OFF',
      AppLanguage.marathi: '⚪ पंप बंद',
      AppLanguage.hindi: '⚪ पंप बंद',
    },
    'turnPumpOn': {
      AppLanguage.english: 'TURN PUMP ON',
      AppLanguage.marathi: 'पंप सुरू करा',
      AppLanguage.hindi: 'पंप चालू करें',
    },
    'turnPumpOff': {
      AppLanguage.english: 'TURN PUMP OFF',
      AppLanguage.marathi: 'पंप बंद करा',
      AppLanguage.hindi: 'पंप बंद करें',
    },
    'emergencyStop': {
      AppLanguage.english: '🛑 EMERGENCY STOP',
      AppLanguage.marathi: '🛑 आपत्कालीन स्टॉप',
      AppLanguage.hindi: '🛑 आपातकालीन स्टॉप',
    },
    'todaysSummary': {
      AppLanguage.english: "TODAY'S SUMMARY",
      AppLanguage.marathi: 'आजचा सारांश',
      AppLanguage.hindi: 'आज का सारांश',
    },
    'todaysRecommendation': {
      AppLanguage.english: "TODAY'S RECOMMENDATION",
      AppLanguage.marathi: 'आजची शिफारस',
      AppLanguage.hindi: 'आज की सिफारिश',
    },
    'nextIrrigation': {
      AppLanguage.english: 'NEXT IRRIGATION',
      AppLanguage.marathi: 'पुढील सिंचन',
      AppLanguage.hindi: 'अगला सिंचाई',
    },
    'noIrrigationScheduled': {
      AppLanguage.english: 'No additional irrigation required today.',
      AppLanguage.marathi: 'आज आणखी सिंचनाची गरज नाही.',
      AppLanguage.hindi: 'आज और सिंचाई की आवश्यकता नहीं है।',
    },
    'farmerMode': {
      AppLanguage.english: 'Farmer Mode (Simple UI)',
      AppLanguage.marathi: 'शेतकरी मोड (सोपा UI)',
      AppLanguage.hindi: 'किसान मोड (सरल UI)',
    },
    'farmerModeSubtitle': {
      AppLanguage.english: 'Large buttons, big text, easy for daily farm use.',
      AppLanguage.marathi: 'मोठे बटणे आणि मजकूर, रोजच्या वापरासाठी सोपे.',
      AppLanguage.hindi: 'बड़े बटन और पाठ, दैनिक उपयोग के लिए सरल।',
    },
    'appearance': {
      AppLanguage.english: 'Appearance',
      AppLanguage.marathi: 'देखावा',
      AppLanguage.hindi: 'उपस्थिति',
    },
    'lightMode': {
      AppLanguage.english: 'Light',
      AppLanguage.marathi: 'लाइट',
      AppLanguage.hindi: 'लाइट',
    },
    'darkMode': {
      AppLanguage.english: 'Dark',
      AppLanguage.marathi: 'डार्क',
      AppLanguage.hindi: 'डार्क',
    },
    'systemTheme': {
      AppLanguage.english: 'System Default',
      AppLanguage.marathi: 'सिस्टम डीफॉल्ट',
      AppLanguage.hindi: 'सिस्टम डिफ़ॉल्ट',
    },
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.marathi: 'भाषा',
      AppLanguage.hindi: 'भाषा',
    },
    'diagnostics': {
      AppLanguage.english: 'Watchdog & Diagnostics',
      AppLanguage.marathi: 'वॉचडॉग आणि निदान',
      AppLanguage.hindi: 'वॉचडॉग और निदान',
    },
    'notifications': {
      AppLanguage.english: 'Notifications',
      AppLanguage.marathi: 'सूचना',
      AppLanguage.hindi: 'सूचनाएं',
    },
    'quickTimer': {
      AppLanguage.english: 'IRRIGATION TIMER',
      AppLanguage.marathi: 'सिंचन टाइमर',
      AppLanguage.hindi: 'सिंचाई टाइमर',
    },
    'startTimer': {
      AppLanguage.english: 'START TIMER',
      AppLanguage.marathi: 'टाइमर सुरू करा',
      AppLanguage.hindi: 'टाइमर चालू करें',
    },
    'stopTimer': {
      AppLanguage.english: 'STOP TIMER',
      AppLanguage.marathi: 'टाइमर थांबवा',
      AppLanguage.hindi: 'टाइमर रोकें',
    },
    'irrigationCompleted': {
      AppLanguage.english: 'Completed',
      AppLanguage.marathi: 'पूर्ण झाले',
      AppLanguage.hindi: 'पूरी हुई',
    },
    'irrigationMissed': {
      AppLanguage.english: 'Missed',
      AppLanguage.marathi: 'हुकले',
      AppLanguage.hindi: 'छूट गई',
    },
    'irrigationInterrupted': {
      AppLanguage.english: 'Interrupted',
      AppLanguage.marathi: 'व्यत्यय आला',
      AppLanguage.hindi: 'बाधित हुई',
    },
    'totalSessions': {
      AppLanguage.english: 'Total Sessions',
      AppLanguage.marathi: 'एकूण सत्रे',
      AppLanguage.hindi: 'कुल सत्र',
    },
    'pumpRuntime': {
      AppLanguage.english: 'Pump Runtime',
      AppLanguage.marathi: 'पंप वेळ',
      AppLanguage.hindi: 'पंप चलने का समय',
    },
    'rangeWarningConnected': {
      AppLanguage.english: 'Controller connected via Bluetooth. Stay within range.',
      AppLanguage.marathi: 'ब्लूटूथने कंट्रोलर जोडले आहे. रेंजमध्ये राहा.',
      AppLanguage.hindi: 'ब्लूटूथ से नियंत्रक कनेक्ट है। सीमा में रहें।',
    },
    'rangeWarningDisconnected': {
      AppLanguage.english: 'Controller disconnected. Move closer to reconnect.',
      AppLanguage.marathi: 'कंट्रोलर डिस्कनेक्ट झाले. पुन्हा जोडण्यासाठी जवळ जा.',
      AppLanguage.hindi: 'नियंत्रक डिस्कनेक्ट हो गया। पुन: कनेक्ट करने के लिए पास आएं।',
    },
    'safetyAlertTitle': {
      AppLanguage.english: '⚠️ Irrigation Interrupted',
      AppLanguage.marathi: '⚠️ सिंचनात व्यत्यय आला',
      AppLanguage.hindi: '⚠️ सिंचाई बाधित हुई',
    },
    'safetyAlertBody': {
      AppLanguage.english: 'Bluetooth connection was lost while the pump was ON. Arduino safety watchdog will turn the pump OFF.',
      AppLanguage.marathi: 'पंप सुरू असताना ब्लूटूथ कनेक्शन तुटले. अर्डुइनो वॉचडॉग पंप बंद करेल.',
      AppLanguage.hindi: 'पंप चालू रहने के दौरान ब्लूटूथ कनेक्शन टूट गया। अरड्यूनो वॉचडॉग पंप बंद कर देगा।',
    },
    'reconnectedTitle': {
      AppLanguage.english: '📡 Controller Reconnected',
      AppLanguage.marathi: '📡 कंट्रोलर पुन्हा जोडले गेले',
      AppLanguage.hindi: '📡 नियंत्रक पुनः कनेक्ट हुआ',
    },
    'reconnectedBody': {
      AppLanguage.english: 'Smart Farm controller is connected again.',
      AppLanguage.marathi: 'स्मार्ट फार्म कंट्रोलर पुन्हा जोडले गेले आहे.',
      AppLanguage.hindi: 'स्मार्ट फार्म नियंत्रक फिर से कनेक्ट हो गया है।',
    },
    'missedIrrigationTitle': {
      AppLanguage.english: '⚠️ Irrigation Missed',
      AppLanguage.marathi: '⚠️ सिंचन हुकले',
      AppLanguage.hindi: '⚠️ सिंचाई छूट गई',
    },
    'missedIrrigationBody': {
      AppLanguage.english: 'Scheduled irrigation could not start because the controller was unavailable.',
      AppLanguage.marathi: 'कंट्रोलर उपलब्ध नसल्यामुळे नियोजनबद्ध सिंचन सुरू होऊ शकले नाही.',
      AppLanguage.hindi: 'नियंत्रक उपलब्ध न होने के कारण निर्धारित सिंचाई शुरू नहीं हो सकी।',
    },
    'irrigationCompletedTitle': {
      AppLanguage.english: '💧 Irrigation Completed',
      AppLanguage.marathi: '💧 सिंचन पूर्ण झाले',
      AppLanguage.hindi: '💧 सिंचाई पूरी हुई',
    },
    'irrigationCompletedBody': {
      AppLanguage.english: 'Irrigation session completed successfully.',
      AppLanguage.marathi: 'सिंचन सत्र यशस्वीरीत्या पूर्ण झाले.',
      AppLanguage.hindi: 'सिंचाई सत्र सफलतापूर्वक पूरा हुआ।',
    },
    'upcomingIrrigationTitle': {
      AppLanguage.english: '⏰ Upcoming Irrigation',
      AppLanguage.marathi: '⏰ आगामी सिंचन',
      AppLanguage.hindi: '⏰ आगामी सिंचाई',
    },
    'upcomingIrrigationBody': {
      AppLanguage.english: 'Scheduled irrigation starts in 15 minutes.',
      AppLanguage.marathi: 'नियोजनबद्ध सिंचन 15 मिनिटांत सुरू होईल.',
      AppLanguage.hindi: 'निर्धारित सिंचाई 15 मिनट में शुरू होगी।',
    },
    'dailySummaryTitle': {
      AppLanguage.english: '🌱 Daily Irrigation Summary',
      AppLanguage.marathi: '🌱 दैनंदिन सिंचन सारांश',
      AppLanguage.hindi: '🌱 दैनिक सिंचाई सारांश',
    },
    'viewHistory': {
      AppLanguage.english: 'VIEW HISTORY',
      AppLanguage.marathi: 'इतिहास पहा',
      AppLanguage.hindi: 'इतिहास देखें',
    },
    'viewSchedules': {
      AppLanguage.english: 'VIEW SCHEDULES',
      AppLanguage.marathi: 'वेळापत्रक पहा',
      AppLanguage.hindi: 'समय सारणी देखें',
    },
    'masterNotifications': {
      AppLanguage.english: 'Master Notifications',
      AppLanguage.marathi: 'मुख्य सूचना',
      AppLanguage.hindi: 'मुख्य सूचनाएं',
    },
    'safetyAlerts': {
      AppLanguage.english: 'Safety Alerts',
      AppLanguage.marathi: 'सुरक्षा सूचना',
      AppLanguage.hindi: 'सुरक्षा अलर्ट',
    },
    'irrigationCompletedNotif': {
      AppLanguage.english: 'Irrigation Completed',
      AppLanguage.marathi: 'सिंचन पूर्ण सूचना',
      AppLanguage.hindi: 'सिंचाई पूर्ण सूचना',
    },
    'missedIrrigationNotif': {
      AppLanguage.english: 'Missed Irrigation',
      AppLanguage.marathi: 'हुकलेले सिंचन सूचना',
      AppLanguage.hindi: 'छूटी सिंचाई सूचना',
    },
    'upcomingReminders': {
      AppLanguage.english: 'Upcoming Reminders',
      AppLanguage.marathi: 'आगामी स्मरणपत्रे',
      AppLanguage.hindi: 'आगामी रिमाइंडर',
    },
    'dailySummaryNotif': {
      AppLanguage.english: 'Daily Summary',
      AppLanguage.marathi: 'दैनंदिन सारांश',
      AppLanguage.hindi: 'दैनिक सारांश',
    },
    'connectionEvents': {
      AppLanguage.english: 'Connection Events',
      AppLanguage.marathi: 'कनेक्शन घटना',
      AppLanguage.hindi: 'कनेक्शन इवेंट्स',
    },
    'notificationPermission': {
      AppLanguage.english: 'Notification Permission',
      AppLanguage.marathi: 'सूचना परवानगी',
      AppLanguage.hindi: 'सूचना अनुमति',
    },
    'enabled': {
      AppLanguage.english: 'Enabled',
      AppLanguage.marathi: 'सक्षम',
      AppLanguage.hindi: 'सक्षम',
    },
    'disabled': {
      AppLanguage.english: 'Disabled',
      AppLanguage.marathi: 'अक्षम',
      AppLanguage.hindi: 'अक्षम',
    },
    'openNotificationSettings': {
      AppLanguage.english: 'OPEN NOTIFICATION SETTINGS',
      AppLanguage.marathi: 'सूचना सेटिंग्ज उघडा',
      AppLanguage.hindi: 'सूचना सेटिंग्स खोलें',
    },
    'locationServicesDisabled': {
      AppLanguage.english: 'Device location services are disabled.',
      AppLanguage.marathi: 'डिव्हाइसची स्थान सेवा अक्षम केली आहे.',
      AppLanguage.hindi: 'डिवाइस स्थान सेवाएं अक्षम हैं।',
    },
    'locationPermissionRequired': {
      AppLanguage.english: 'Location permission is required for local weather.',
      AppLanguage.marathi: 'स्थानिक हवामानाची माहिती मिळवण्यासाठी स्थानाची परवानगी आवश्यक आहे.',
      AppLanguage.hindi: 'स्थानीय मौसम की जानकारी प्राप्त करने के लिए स्थान की अनुमति आवश्यक है।',
    },
    'locationPermissionDisabled': {
      AppLanguage.english: 'Location permission is disabled for Smart Farm.',
      AppLanguage.marathi: 'स्मार्ट फार्मसाठी स्थान परवानगी अक्षम केली आहे.',
      AppLanguage.hindi: 'स्मार्ट फार्म के लिए स्थान अनुमति अक्षम है।',
    },
    'weather': {
      AppLanguage.english: 'WEATHER',
      AppLanguage.marathi: 'हवामान',
      AppLanguage.hindi: 'मौसम',
    },
    'weatherUnavailable': {
      AppLanguage.english: 'Weather Unavailable',
      AppLanguage.marathi: 'हवामान उपलब्ध नाही',
      AppLanguage.hindi: 'मौसम उपलब्ध नहीं',
    },
    'tryAgain': {
      AppLanguage.english: 'TRY AGAIN',
      AppLanguage.marathi: 'पुन्हा प्रयत्न करा',
      AppLanguage.hindi: 'पुनः प्रयास करें',
    },
    'enableLocation': {
      AppLanguage.english: 'ENABLE LOCATION',
      AppLanguage.marathi: 'स्थान सक्षम करा',
      AppLanguage.hindi: 'स्थान सक्षम करें',
    },
    'gettingLocalWeather': {
      AppLanguage.english: 'Getting local weather...',
      AppLanguage.marathi: 'स्थानिक हवामान मिळवत आहे...',
      AppLanguage.hindi: 'स्थानीय मौसम प्राप्त किया जा रहा है...',
    },
    'locationUnavailable': {
      AppLanguage.english: 'Location Unavailable',
      AppLanguage.marathi: 'स्थान उपलब्ध नाही',
      AppLanguage.hindi: 'स्थान उपलब्ध नहीं',
    },
    'locationPermissionExplanation': {
      AppLanguage.english: 'Weather-based irrigation recommendations use your current location to retrieve local weather information.',
      AppLanguage.marathi: 'हवामान-आधारित सिंचन शिफारशी स्थानिक हवामान माहिती मिळवण्यासाठी तुमचे सध्याचे स्थान वापरतात.',
      AppLanguage.hindi: 'मौसम-आधारित सिंचाई सिफारिशें स्थानीय मौसम जानकारी प्राप्त करने के लिए आपके वर्तमान स्थान का उपयोग करती हैं।',
    },
    'weatherDataOutdated': {
      AppLanguage.english: 'Weather data may be outdated',
      AppLanguage.marathi: 'हवामान डेटा जुना असू शकतो',
      AppLanguage.hindi: 'मौसम डेटा पुराना हो सकता है',
    },
    'lastUpdated': {
      AppLanguage.english: 'Last updated',
      AppLanguage.marathi: 'शेवटचे अपडेट',
      AppLanguage.hindi: 'अंतिम अपडेट',
    },
    'minutesAgo': {
      AppLanguage.english: '{count}m ago',
      AppLanguage.marathi: '{count} मि पूर्वी',
      AppLanguage.hindi: '{count} मि पहले',
    },
    'justNow': {
      AppLanguage.english: 'just now',
      AppLanguage.marathi: 'आत्ताच',
      AppLanguage.hindi: 'अभी',
    },
    'refresh': {
      AppLanguage.english: 'Refresh',
      AppLanguage.marathi: 'रिफ्रेश करा',
      AppLanguage.hindi: 'ताज़ा करें',
    },
    'openSettings': {
      AppLanguage.english: 'OPEN SETTINGS',
      AppLanguage.marathi: 'सेटिंग्ज उघडा',
      AppLanguage.hindi: 'सेटिंग्स खोलें',
    },
    'rainProbability': {
      AppLanguage.english: 'Rain probability',
      AppLanguage.marathi: 'पावसाची शक्यता',
      AppLanguage.hindi: 'बारिश की संभावना',
    },
    'farmAnalytics': {
      AppLanguage.english: 'FARM ANALYTICS',
      AppLanguage.marathi: 'फार्म विश्लेषण',
      AppLanguage.hindi: 'फार्म विश्लेषण',
    },
    'today': {
      AppLanguage.english: "TODAY'S ANALYTICS",
      AppLanguage.marathi: 'आजचे विश्लेषण',
      AppLanguage.hindi: 'आज का विश्लेषण',
    },
    'thisWeek': {
      AppLanguage.english: 'THIS WEEK',
      AppLanguage.marathi: 'या आठवड्यात',
      AppLanguage.hindi: 'इस सप्ताह',
    },
    'clearSky': {
      AppLanguage.english: 'Clear Sky',
      AppLanguage.marathi: 'निरभ्र आकाश',
      AppLanguage.hindi: 'साफ आसमान',
    },
    'partlyCloudy': {
      AppLanguage.english: 'Partly Cloudy',
      AppLanguage.marathi: 'भागशः ढगाळ',
      AppLanguage.hindi: 'आंशिक रूप से बादल',
    },
    'cloudy': {
      AppLanguage.english: 'Cloudy',
      AppLanguage.marathi: 'ढगाळ',
      AppLanguage.hindi: 'बादल छाए हैं',
    },
    'rainy': {
      AppLanguage.english: 'Rain',
      AppLanguage.marathi: 'पाऊस',
      AppLanguage.hindi: 'बारिश',
    },
    'heavyRain': {
      AppLanguage.english: 'Heavy Rain',
      AppLanguage.marathi: 'मुसळधार पाऊस',
      AppLanguage.hindi: 'भारी बारिश',
    },
    'thunderstorm': {
      AppLanguage.english: 'Thunderstorm',
      AppLanguage.marathi: 'वादळी पाऊस',
      AppLanguage.hindi: 'आंधी-तूफान',
    },
    'skipOnce': {
      AppLanguage.english: 'SKIP ONCE',
      AppLanguage.marathi: 'एकदा गमवा',
      AppLanguage.hindi: 'एक बार छोड़ें',
    },
    'irrigateAnyway': {
      AppLanguage.english: 'IRRIGATE ANYWAY',
      AppLanguage.marathi: 'तरीही सिंचन करा',
      AppLanguage.hindi: 'फिर भी सिंचाई करें',
    },
    'runNow': {
      AppLanguage.english: 'RUN NOW',
      AppLanguage.marathi: 'आत्ता सुरू करा',
      AppLanguage.hindi: 'अभी चालू करें',
    },
    'recentRainfallDetected': {
      AppLanguage.english: 'Recent rainfall detected from local forecast.',
      AppLanguage.marathi: 'स्थानिक अंदाजावरून नुकताच पाऊस पडल्याचे आढळले आहे.',
      AppLanguage.hindi: 'स्थानीय पूर्वानुमान से हाल ही में बारिश का पता चला है।',
    },
        'weatherOverview': {
      AppLanguage.english: 'Weather Overview',
      AppLanguage.marathi: 'हवामान सारांश',
      AppLanguage.hindi: 'मौसम विवरण',
    },
    'morning': {
      AppLanguage.english: 'Morning',
      AppLanguage.marathi: 'सकाळ',
      AppLanguage.hindi: 'सुबह',
    },
    'afternoon': {
      AppLanguage.english: 'Afternoon',
      AppLanguage.marathi: 'दुपार',
      AppLanguage.hindi: 'दोपहर',
    },
    'evening': {
      AppLanguage.english: 'Evening',
      AppLanguage.marathi: 'संध्याकाळ',
      AppLanguage.hindi: 'शाम',
    },
    'night': {
      AppLanguage.english: 'Night',
      AppLanguage.marathi: 'रात्र',
      AppLanguage.hindi: 'रात',
    },
    'todaysHigh': {
      AppLanguage.english: 'High',
      AppLanguage.marathi: 'उच्च',
      AppLanguage.hindi: 'अधिकतम',
    },
    'todaysLow': {
      AppLanguage.english: 'Low',
      AppLanguage.marathi: 'कमी',
      AppLanguage.hindi: 'न्यूनतम',
    },
    'expectedRainfall': {
      AppLanguage.english: 'Expected rain',
      AppLanguage.marathi: 'अपेक्षित पाऊस',
      AppLanguage.hindi: 'अपेक्षित बारिश',
    },
    'viewFullForecast': {
      AppLanguage.english: 'VIEW FULL FORECAST',
      AppLanguage.marathi: 'संपूर्ण अंदाज पहा',
      AppLanguage.hindi: 'पूरा पूर्वानुमान देखें',
    },
    'weatherDetailsTitle': {
      AppLanguage.english: 'WEATHER DETAILS',
      AppLanguage.marathi: 'हवामान तपशील',
      AppLanguage.hindi: 'मौसम विवरण',
    },
    'irrigationOutlook': {
      AppLanguage.english: 'Irrigation Outlook',
      AppLanguage.marathi: 'सिंचन दृष्टीकोन',
      AppLanguage.hindi: 'सिंचाई दृष्टिकोण',
    },
    'hourlyForecast': {
      AppLanguage.english: 'Hourly Forecast',
      AppLanguage.marathi: 'ताशी अंदाज',
      AppLanguage.hindi: 'प्रति घंटा पूर्वानुमान',
    },
    'confirmSkipTitle': {
      AppLanguage.english: 'Skip Today\'s Irrigation?',
      AppLanguage.marathi: 'आजचे सिंचन वगळायचे?',
      AppLanguage.hindi: 'आज की सिंचाई छोड़ें?',
    },
    'scheduleSkippedToday': {
      AppLanguage.english: 'Irrigation skipped for today.',
      AppLanguage.marathi: 'आजचे सिंचन वगळले आहे.',
      AppLanguage.hindi: 'आज की सिंचाई छोड़ दी गई है।',
    },
    'irrigationFavorableOutlook': {
      AppLanguage.english: 'Morning hours appear to have a lower rain probability than evening.',
      AppLanguage.marathi: 'संध्याकाळपेक्षा सकाळच्या वेळी पावसाची शक्यता कमी दिसते.',
      AppLanguage.hindi: 'शाम की तुलना में सुबह के समय बारिश की संभावना कम प्रतीत होती है।',
    },
    'staleWeatherWarning': {
      AppLanguage.english: 'Weather data is outdated. Refresh to get the latest recommendation.',
      AppLanguage.marathi: 'हवामान डेटा जुना आहे. नवीन शिफारशीसाठी रिफ्रेश करा.',
      AppLanguage.hindi: 'मौसम डेटा पुराना है। नवीनतम सिफारिश के लिए ताज़ा करें।',
    },
    'offlineIrrigationNotice': {
      AppLanguage.english: 'Your irrigation controls remain fully available offline.',
      AppLanguage.marathi: 'तुमची सिंचन नियंत्रणे ऑफलाइन देखील उपलब्ध आहेत.',
      AppLanguage.hindi: 'आपके सिंचाई नियंत्रण ऑफलाइन भी उपलब्ध हैं।',
    },
  };

  static String tr(String key, AppLanguage lang) {
    if (_localizedValues.containsKey(key)) {
      final map = _localizedValues[key]!;
      if (map.containsKey(lang) && map[lang]!.isNotEmpty) {
        return map[lang]!;
      }
      if (map.containsKey(AppLanguage.english) && map[AppLanguage.english]!.isNotEmpty) {
        return map[AppLanguage.english]!;
      }
    }

    // Case-insensitive key lookup fallback
    final keyLower = key.toLowerCase();
    for (final entry in _localizedValues.entries) {
      if (entry.key.toLowerCase() == keyLower) {
        final map = entry.value;
        if (map.containsKey(lang) && map[lang]!.isNotEmpty) {
          return map[lang]!;
        }
        if (map.containsKey(AppLanguage.english) && map[AppLanguage.english]!.isNotEmpty) {
          return map[AppLanguage.english]!;
        }
      }
    }

    return key;
  }
}

