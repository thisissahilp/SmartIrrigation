import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_translations.dart';
import '../models/weather_data.dart';
import '../services/settings_service.dart';
import '../services/weather_service.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final VoidCallback? onNavigateToSchedules;

  const WeatherDetailsScreen({
    super.key,
    this.onNavigateToSchedules,
  });

  @override
  Widget build(BuildContext context) {
    final weatherService = WeatherService();
    final settingsService = SettingsService();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.weatherDetailsTitle ?? AppTranslations.tr('weatherDetailsTitle', settingsService.language),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([weatherService, settingsService]),
        builder: (context, _) {
          final lang = settingsService.language;
          final weather = weatherService.weatherData;
          final isLoading = weatherService.isLoading;

          if (isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF0288D1)),
                  const SizedBox(height: 16),
                  Text(
                    l10n?.gettingLocalWeather ?? AppTranslations.tr('gettingLocalWeather', lang),
                    style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          if (weather == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, size: 64, color: Colors.orange.shade800),
                    const SizedBox(height: 16),
                    Text(
                      l10n?.weatherUnavailable ?? AppTranslations.tr('weatherUnavailable', lang),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n?.offlineIrrigationNotice ?? AppTranslations.tr('offlineIrrigationNotice', lang),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0288D1),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n?.tryAgain ?? AppTranslations.tr('tryAgain', lang)),
                      onPressed: () => weatherService.enableLocationAndFetchWeather(forceRefresh: true),
                    ),
                  ],
                ),
              ),
            );
          }

          final daySegments = weather.getDaySegments();
          final hourlyItems = weather.getTodayHourlyForecast();
          final naturalSummary = _generateNaturalSummary(weather, daySegments, lang, l10n);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. MAIN OVERVIEW CARD
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFF0288D1), size: 20),
                                const SizedBox(width: 6),
                                Text(
                                  weather.locationName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Color(0xFF0288D1)),
                              tooltip: l10n?.refresh ?? AppTranslations.tr('refresh', lang),
                              onPressed: () => weatherService.enableLocationAndFetchWeather(forceRefresh: true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${weather.temperature.toStringAsFixed(0)}°C',
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0288D1),
                                  ),
                                ),
                                Text(
                                  weather.getWeatherCondition(lang),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            Icon(weather.weatherIcon, size: 64, color: const Color(0xFF0288D1)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildOverviewStat(
                              icon: Icons.arrow_upward,
                              color: Colors.red.shade700,
                              label: l10n?.todaysHigh ?? AppTranslations.tr('todaysHigh', lang),
                              value: '${weather.tempMaxToday.toStringAsFixed(0)}°C',
                            ),
                            _buildOverviewStat(
                              icon: Icons.arrow_downward,
                              color: Colors.blue.shade700,
                              label: l10n?.todaysLow ?? AppTranslations.tr('todaysLow', lang),
                              value: '${weather.tempMinToday.toStringAsFixed(0)}°C',
                            ),
                            _buildOverviewStat(
                              icon: Icons.water_drop,
                              color: const Color(0xFF0288D1),
                              label: l10n?.rainProbability ?? AppTranslations.tr('rainProbability', lang),
                              value: '${weather.maxRainProbabilityToday}%',
                            ),
                            _buildOverviewStat(
                              icon: Icons.grain,
                              color: Colors.indigo,
                              label: l10n?.expectedRainfall ?? AppTranslations.tr('expectedRainfall', lang),
                              value: '${weather.expectedRainfallSumToday.toStringAsFixed(1)} mm',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. NATURAL FARMER SUMMARY CARD
                Card(
                  elevation: 2,
                  color: Colors.lightGreen.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wb_sunny, color: Color(0xFF2E7D32), size: 22),
                            const SizedBox(width: 8),
                            Text(
                              l10n?.weatherOverview ?? AppTranslations.tr('weatherOverview', lang),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          naturalSummary,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. DAY SEGMENTS SUMMARY
                Text(
                  l10n?.today ?? AppTranslations.tr('today', lang),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  children: daySegments.map((seg) {
                    final label = _getSegmentName(seg.segment, lang, l10n);
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Icon(seg.weatherIcon, size: 28, color: const Color(0xFF0288D1)),
                            const SizedBox(height: 6),
                            Text(
                              '${seg.temperature.toStringAsFixed(0)}°C',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: seg.rainProbability >= 50
                                    ? Colors.blue.shade100
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${seg.rainProbability}%',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: seg.rainProbability >= 50
                                      ? Colors.blue.shade900
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 4. HOURLY FORECAST (24H)
                Text(
                  l10n?.hourlyForecast ?? AppTranslations.tr('hourlyForecast', lang),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hourlyItems.length,
                    itemBuilder: (context, index) {
                      final item = hourlyItems[index];
                      return Container(
                        width: 72,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.formattedHour,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Icon(item.weatherIcon, size: 22, color: const Color(0xFF0288D1)),
                            const SizedBox(height: 4),
                            Text(
                              '${item.temperature.toStringAsFixed(0)}°',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            if (item.rainProbability >= 20)
                              Text(
                                '${item.rainProbability}%',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0288D1),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // 5. IRRIGATION OUTLOOK ADVISORY
                Card(
                  elevation: 2,
                  color: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.eco_outlined, color: Color(0xFF0288D1), size: 22),
                            const SizedBox(width: 8),
                            Text(
                              l10n?.irrigationOutlook ?? AppTranslations.tr('irrigationOutlook', lang),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF0288D1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n?.irrigationFavorableOutlook ?? AppTranslations.tr('irrigationFavorableOutlook', lang),
                          style: TextStyle(fontSize: 13, color: Colors.blue.shade900, height: 1.35),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0288D1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if (onNavigateToSchedules != null) {
                                onNavigateToSchedules!();
                              }
                            },
                            child: Text(
                              l10n?.viewSchedules ?? AppTranslations.tr('viewSchedules', lang),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewStat({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  String _getSegmentName(DaySegment segment, AppLanguage lang, AppLocalizations? l10n) {
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

  String _generateNaturalSummary(WeatherData weather, List<DaySegmentForecast> segments, AppLanguage lang, AppLocalizations? l10n) {
    final condition = weather.getWeatherCondition(lang);
    final tempRange = '${weather.tempMinToday.toStringAsFixed(0)}°C – ${weather.tempMaxToday.toStringAsFixed(0)}°C';

    String rainSummary = 'Low chance of rain today';
    final evening = segments.firstWhere((s) => s.segment == DaySegment.evening, orElse: () => segments.first);
    final morning = segments.firstWhere((s) => s.segment == DaySegment.morning, orElse: () => segments.first);

    if (weather.maxRainProbabilityToday >= 70) {
      if (evening.rainProbability >= 60) {
        rainSummary = 'High chance of rain expected in the evening.';
      } else if (morning.rainProbability >= 60) {
        rainSummary = 'High chance of rain expected in the morning.';
      } else {
        rainSummary = 'High chance of rain likely today.';
      }
    } else if (weather.maxRainProbabilityToday >= 40) {
      rainSummary = 'Moderate chance of rain may occur today.';
    }

    final rainAmountStr = weather.expectedRainfallSumToday > 0.0
        ? 'Expected rain: ${weather.expectedRainfallSumToday.toStringAsFixed(1)} mm.'
        : '';

    return '$condition today. Temperature: $tempRange. $rainSummary $rainAmountStr';
  }
}
