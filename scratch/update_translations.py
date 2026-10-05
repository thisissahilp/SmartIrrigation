import json

new_keys = {
    'weatherOverview': {'en': 'Weather Overview', 'mr': 'हवामान सारांश', 'hi': 'मौसम विवरण'},
    'morning': {'en': 'Morning', 'mr': 'सकाळ', 'hi': 'सुबह'},
    'afternoon': {'en': 'Afternoon', 'mr': 'दुपार', 'hi': 'दोपहर'},
    'evening': {'en': 'Evening', 'mr': 'संध्याकाळ', 'hi': 'शाम'},
    'night': {'en': 'Night', 'mr': 'रात्र', 'hi': 'रात'},
    'todaysHigh': {'en': 'High', 'mr': 'उच्च', 'hi': 'अधिकतम'},
    'todaysLow': {'en': 'Low', 'mr': 'कमी', 'hi': 'न्यूनतम'},
    'expectedRainfall': {'en': 'Expected rain', 'mr': 'अपेक्षित पाऊस', 'hi': 'अपेक्षित बारिश'},
    'viewFullForecast': {'en': 'VIEW FULL FORECAST', 'mr': 'संपूर्ण अंदाज पहा', 'hi': 'पूरा पूर्वानुमान देखें'},
    'weatherDetailsTitle': {'en': 'WEATHER DETAILS', 'mr': 'हवामान तपशील', 'hi': 'मौसम विवरण'},
    'irrigationOutlook': {'en': 'Irrigation Outlook', 'mr': 'सिंचन दृष्टीकोन', 'hi': 'सिंचाई दृष्टिकोण'},
    'hourlyForecast': {'en': 'Hourly Forecast', 'mr': 'ताशी अंदाज', 'hi': 'प्रति घंटा पूर्वानुमान'},
    'confirmSkipTitle': {'en': 'Skip Today\'s Irrigation?', 'mr': 'आजचे सिंचन वगळायचे?', 'hi': 'आज की सिंचाई छोड़ें?'},
    'scheduleSkippedToday': {'en': 'Irrigation skipped for today.', 'mr': 'आजचे सिंचन वगळले आहे.', 'hi': 'आज की सिंचाई छोड़ दी गई है।'},
    'irrigationFavorableOutlook': {'en': 'Morning hours appear to have a lower rain probability than evening.', 'mr': 'संध्याकाळपेक्षा सकाळच्या वेळी पावसाची शक्यता कमी दिसते.', 'hi': 'शाम की तुलना में सुबह के समय बारिश की संभावना कम प्रतीत होती है।'},
    'staleWeatherWarning': {'en': 'Weather data is outdated. Refresh to get the latest recommendation.', 'mr': 'हवामान डेटा जुना आहे. नवीन शिफारशीसाठी रिफ्रेश करा.', 'hi': 'मौसम डेटा पुराना है। नवीनतम सिफारिश के लिए ताज़ा करें।'}
}

with open('lib/l10n/app_translations.dart', 'r', encoding='utf-8') as f:
    content = f.read()

insert_lines = []
for k, v in new_keys.items():
    if f"'{k}':" not in content:
        insert_lines.append(f"    '{k}': {{")
        insert_lines.append(f"      AppLanguage.english: '{v['en']}',")
        insert_lines.append(f"      AppLanguage.marathi: '{v['mr']}',")
        insert_lines.append(f"      AppLanguage.hindi: '{v['hi']}',")
        insert_lines.append("    },")

if insert_lines:
    insert_str = '\n'.join(insert_lines) + '\n'
    content = content.replace("'offlineIrrigationNotice': {", insert_str + "    'offlineIrrigationNotice': {")

    with open('lib/l10n/app_translations.dart', 'w', encoding='utf-8') as f:
        f.write(content)

print('Successfully updated app_translations.dart')
