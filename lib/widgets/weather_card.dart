import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_translations.dart';
import '../models/weather_data.dart';
import '../screens/weather_details_screen.dart';
import '../services/settings_service.dart';
import '../services/weather_service.dart';

class WeatherCard extends StatelessWidget {
  final VoidCallback? onNavigateToSchedules;

  const WeatherCard({
    super.key,
    this.onNavigateToSchedules,
  });

  @override
  Widget build(BuildContext context) {
    final weatherService = WeatherService();
    final settingsService = SettingsService();
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([weatherService, settingsService]),
      builder: (context, _) {
        final lang = settingsService.language;
        final weather = weatherService.weatherData;
        final isLoading = weatherService.isLoading;
        final locationStatus = weatherService.locationStatus;
        final lastError = weatherService.lastError;

        final titleText = l10n?.weather ?? AppTranslations.tr('weather', lang);
        final refreshTooltip = l10n?.refresh ?? AppTranslations.tr('refresh', lang);
        final gettingWeatherText = l10n?.gettingLocalWeather ?? AppTranslations.tr('gettingLocalWeather', lang);
        final locDisabledTitle = l10n?.locationServicesDisabled ?? AppTranslations.tr('locationServicesDisabled', lang);
        final locExplanationText = l10n?.locationPermissionExplanation ?? AppTranslations.tr('locationPermissionExplanation', lang);
        final enableLocBtnText = l10n?.enableLocation ?? AppTranslations.tr('enableLocation', lang);
        final permDisabledTitle = l10n?.locationPermissionDisabled ?? AppTranslations.tr('locationPermissionDisabled', lang);
        final openSettingsBtnText = l10n?.openSettings ?? AppTranslations.tr('openSettings', lang);
        final permRequiredTitle = l10n?.locationPermissionRequired ?? AppTranslations.tr('locationPermissionRequired', lang);
        final weatherUnavailTitle = l10n?.weatherUnavailable ?? AppTranslations.tr('weatherUnavailable', lang);
        final offlineNoticeText = l10n?.offlineIrrigationNotice ?? AppTranslations.tr('offlineIrrigationNotice', lang);
        final tryAgainBtnText = l10n?.tryAgain ?? AppTranslations.tr('tryAgain', lang);
        final dataOutdatedText = l10n?.weatherDataOutdated ?? AppTranslations.tr('weatherDataOutdated', lang);
        final viewFullForecastText = l10n?.viewFullForecast ?? AppTranslations.tr('viewFullForecast', lang);

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny_outlined, color: Color(0xFF0288D1), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          titleText,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    if (weather != null && !isLoading)
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 20, color: Color(0xFF0288D1)),
                        tooltip: refreshTooltip,
                        onPressed: () => weatherService.enableLocationAndFetchWeather(forceRefresh: true),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // 1. LOADING STATE
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF0288D1)),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          gettingWeatherText,
                          style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )

                // 2. DEVICE LOCATION SERVICES DISABLED STATE
                else if (locationStatus == LocationStatus.serviceDisabled)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_off_outlined, color: Colors.amber.shade900, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                locDisabledTitle,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          locExplanationText,
                          style: TextStyle(fontSize: 12, color: Colors.amber.shade900, height: 1.3),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            icon: const Icon(Icons.location_searching, size: 16),
                            label: Text(
                              enableLocBtnText,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            onPressed: () async {
                              await weatherService.openLocationSettings();
                            },
                          ),
                        ),
                      ],
                    ),
                  )

                // 3. PERMISSION PERMANENTLY DENIED STATE
                else if (locationStatus == LocationStatus.permanentlyDenied)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.security, color: Colors.orange.shade900, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                permDisabledTitle,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade900, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          locExplanationText,
                          style: TextStyle(fontSize: 12, color: Colors.orange.shade900, height: 1.3),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade900,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            icon: const Icon(Icons.settings, size: 16),
                            label: Text(
                              openSettingsBtnText,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            onPressed: () async {
                              await weatherService.openAppSettings();
                            },
                          ),
                        ),
                      ],
                    ),
                  )

                // 4. PERMISSION DENIED OR INITIAL UNPROMPTED STATE
                else if (weather == null && lastError == null && locationStatus != LocationStatus.granted)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          permRequiredTitle,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          locExplanationText,
                          style: TextStyle(fontSize: 12, color: Colors.blue.shade800, height: 1.3),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0288D1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            icon: const Icon(Icons.my_location, size: 16),
                            label: Text(
                              enableLocBtnText,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            onPressed: () async {
                              await weatherService.enableLocationAndFetchWeather();
                            },
                          ),
                        ),
                      ],
                    ),
                  )

                // 5. ERROR / UNABLE TO RETRIEVE WEATHER
                else if (weather == null && lastError != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cloud_off, color: Colors.orange.shade800, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              weatherUnavailTitle,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade900, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offlineNoticeText,
                          style: TextStyle(fontSize: 12, color: Colors.orange.shade800),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange.shade900,
                              side: BorderSide(color: Colors.orange.shade800),
                            ),
                            icon: const Icon(Icons.refresh, size: 16),
                            label: Text(tryAgainBtnText),
                            onPressed: () => weatherService.enableLocationAndFetchWeather(forceRefresh: true),
                          ),
                        ),
                      ],
                    ),
                  )

                // 6. SUCCESS / CACHED WEATHER DISPLAY
                else if (weather != null) ...[
                  if (weather.isStale)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.amber.shade900),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              dataOutdatedText,
                              style: TextStyle(fontSize: 11, color: Colors.amber.shade900, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Color(0xFF0288D1)),
                              const SizedBox(width: 4),
                              Text(
                                weather.locationName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${weather.temperature.toStringAsFixed(0)}°C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0288D1),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                weather.getWeatherCondition(lang),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(weather.weatherIcon, size: 48, color: const Color(0xFF0288D1)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // High / Low & Rain info summary row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today: ${weather.tempMinToday.toStringAsFixed(0)}° – ${weather.tempMaxToday.toStringAsFixed(0)}°',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Rain: ${weather.maxRainProbabilityToday}% (${weather.expectedRainfallSumToday.toStringAsFixed(1)}mm)',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0288D1)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Day segments preview
                  Row(
                    children: weather.getDaySegments().map((seg) {
                      final segName = _getSegmentShortName(seg.segment, lang, l10n);
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              Text(
                                segName,
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Icon(seg.weatherIcon, size: 18, color: const Color(0xFF0288D1)),
                              const SizedBox(height: 2),
                              Text(
                                '${seg.temperature.toStringAsFixed(0)}°',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${seg.rainProbability}%',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: seg.rainProbability >= 50 ? Colors.blue.shade900 : Colors.grey.shade600,
                                  fontWeight: seg.rainProbability >= 50 ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Bottom action bar: View Details & Updated Timestamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getFormattedTimestamp(weather.timestamp, lang, l10n),
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0288D1),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.arrow_forward, size: 14),
                        label: Text(
                          viewFullForecastText,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeatherDetailsScreen(
                                onNavigateToSchedules: onNavigateToSchedules,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getSegmentShortName(DaySegment segment, AppLanguage lang, AppLocalizations? l10n) {
    switch (segment) {
      case DaySegment.morning:
        return l10n?.morning ?? AppTranslations.tr('morning', lang);
      case DaySegment.afternoon:
        return l10n?.afternoon ?? AppTranslations.tr('afternoon', lang);
      case DaySegment.evening:
        return l10n?.evening ?? AppTranslations.tr('evening', lang);
      case DaySegment.night:
        return l10n?.night ?? AppTranslations.tr('night', lang);
    }
  }

  String _getFormattedTimestamp(DateTime timestamp, AppLanguage lang, AppLocalizations? l10n) {
    final diffMins = DateTime.now().difference(timestamp).inMinutes;
    if (diffMins <= 1) {
      return l10n?.justNow ?? AppTranslations.tr('justNow', lang);
    }
    final lastUpdatedStr = l10n?.lastUpdated ?? AppTranslations.tr('lastUpdated', lang);
    final minsAgoStr = l10n != null
        ? l10n.minutesAgo(diffMins)
        : AppTranslations.tr('minutesAgo', lang).replaceAll('{count}', diffMins.toString());
    return '$lastUpdatedStr $minsAgoStr';
  }
}
