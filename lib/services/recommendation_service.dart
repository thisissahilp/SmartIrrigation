import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_translations.dart';
import '../models/irrigation_schedule.dart';
import 'irrigation_service.dart';
import 'notification_service.dart';
import 'settings_service.dart';
import 'weather_service.dart';

enum RecommendationType {
  safetyInterruption,
  missed,
  rainExpected,
  rainPossible,
  recentRainfall,
  upcoming,
  completed,
  noSchedule,
}

class RecommendationResult {
  final RecommendationType type;
  final String title;
  final String message;
  final int? rainProbability;
  final double? expectedPrecipitation;
  final String? primaryActionLabel;
  final String? secondaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final IrrigationSchedule? targetSchedule;

  RecommendationResult({
    required this.type,
    required this.title,
    required this.message,
    this.rainProbability,
    this.expectedPrecipitation,
    this.primaryActionLabel,
    this.secondaryActionLabel,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.targetSchedule,
  });
}

class RecommendationService {
  static final RecommendationService _instance = RecommendationService._internal();
  factory RecommendationService() => _instance;
  RecommendationService._internal();

  RecommendationResult evaluateRecommendation({
    required BuildContext context,
    required Function(String route) onNavigate,
  }) {
    final irrigation = IrrigationService();
    final bluetooth = BluetoothService();
    final weatherService = WeatherService();
    final settings = SettingsService();
    final lang = settings.language;

    final now = DateTime.now();
    final isConnected = bluetooth.connectionState == BtcConnectionState.connected;
    final weather = weatherService.weatherData;

    // PRIORITY 1: Safety / Interruption Alert
    if (irrigation.lastInterruptedSession != null) {
      return RecommendationResult(
        type: RecommendationType.safetyInterruption,
        title: '⚠️ ${AppTranslations.tr('safetyAlertTitle', lang)}',
        message: AppTranslations.tr('safetyAlertBody', lang),
        primaryActionLabel: AppTranslations.tr('viewHistory', lang),
        onPrimaryAction: () {
          irrigation.clearLastInterruptedSession();
          onNavigate('history');
        },
      );
    }

    // PRIORITY 2: Missed Irrigation Today
    if (irrigation.todayMissedCount > 0) {
      return RecommendationResult(
        type: RecommendationType.missed,
        title: '⚠️ ${AppTranslations.tr('todaysRecommendation', lang)}',
        message: 'Scheduled irrigation was missed today because the controller was unavailable.',
        primaryActionLabel: isConnected ? AppTranslations.tr('runNow', lang) : AppTranslations.tr('viewHistory', lang),
        onPrimaryAction: () {
          if (isConnected) {
            irrigation.startManualIrrigation();
          } else {
            onNavigate('history');
          }
        },
      );
    }

    // PRIORITY 3: Rain Expected / Rain Possible around Active/Upcoming Schedule Today
    if (weather != null && !weather.isStale) {
      for (final schedule in irrigation.schedules) {
        if (!schedule.enabled) continue;
        if (irrigation.isScheduleSkippedToday(schedule.id)) continue;
        if (irrigation.isRainWarningDismissedToday(schedule.id)) continue;

        // Look up forecast for schedule window
        final windowInfo = weather.getRainInfoForScheduleWindow(schedule.startTime, schedule.duration);

        if (windowInfo.maxRainProbability >= 70 && windowInfo.expectedPrecipitation > 0.1) {
          final timeStr = schedule.formattedStartTime;
          final eventId = 'rain_exp_${schedule.id}_${now.year}${now.month}${now.day}';

          // Trigger deduplicated smart notification
          NotificationService().triggerWeatherRainWarningNotification(
            eventId: eventId,
            title: '🌧️ ${AppTranslations.tr('weatherRainTitle', lang)}',
            message: 'High chance of rain (${windowInfo.maxRainProbability}%) expected around $timeStr for ${schedule.name}. Consider skipping.',
          );

          return RecommendationResult(
            type: RecommendationType.rainExpected,
            title: '🌧️ ${AppTranslations.tr('weatherRainTitle', lang)}',
            message: 'Your $timeStr irrigation (${schedule.name}) has a high chance of rain around the scheduled time. Rain probability: ${windowInfo.maxRainProbability}%, Expected rain: ${windowInfo.expectedPrecipitation.toStringAsFixed(1)} mm. Consider skipping this irrigation.',
            rainProbability: windowInfo.maxRainProbability,
            expectedPrecipitation: windowInfo.expectedPrecipitation,
            primaryActionLabel: AppTranslations.tr('skipOnce', lang),
            secondaryActionLabel: AppTranslations.tr('irrigateAnyway', lang),
            onPrimaryAction: () async {
              await irrigation.skipScheduleOnce(
                schedule,
                reason: 'Skipped once by farmer due to rain forecast (${windowInfo.maxRainProbability}%).',
              );
            },
            onSecondaryAction: () {
              irrigation.dismissRainWarningForSchedule(schedule.id);
            },
            targetSchedule: schedule,
          );
        } else if (windowInfo.maxRainProbability >= 40) {
          final timeStr = schedule.formattedStartTime;
          return RecommendationResult(
            type: RecommendationType.rainPossible,
            title: '🌦️ Rain Possible',
            message: 'Rain may occur around your $timeStr schedule (${schedule.name}). Rain probability: ${windowInfo.maxRainProbability}%.',
            rainProbability: windowInfo.maxRainProbability,
            expectedPrecipitation: windowInfo.expectedPrecipitation,
            primaryActionLabel: AppTranslations.tr('skipOnce', lang),
            secondaryActionLabel: AppTranslations.tr('irrigateAnyway', lang),
            onPrimaryAction: () async {
              await irrigation.skipScheduleOnce(
                schedule,
                reason: 'Skipped once by farmer due to rain forecast (${windowInfo.maxRainProbability}%).',
              );
            },
            onSecondaryAction: () {
              irrigation.dismissRainWarningForSchedule(schedule.id);
            },
            targetSchedule: schedule,
          );
        }
      }
    }

    // PRIORITY 4: Recent Rainfall Detected
    if (weather != null && !weather.isStale) {
      final recentPrecip = weather.getRecentPrecipitation(12);
      if (recentPrecip > 2.0 || weather.precipitation > 2.0 || weather.rain > 2.0) {
        final amount = recentPrecip > 0 ? recentPrecip : weather.precipitation;
        return RecommendationResult(
          type: RecommendationType.recentRainfall,
          title: '🌧️ ${AppTranslations.tr('recentRainfallDetected', lang)}',
          message: 'Recent rainfall (${amount.toStringAsFixed(1)}mm) was detected near your location. This may reduce the need for upcoming irrigation.',
          expectedPrecipitation: amount,
          primaryActionLabel: AppTranslations.tr('viewSchedules', lang),
          onPrimaryAction: () => onNavigate('schedules'),
        );
      }
    }

    // Find upcoming schedule for today
    IrrigationSchedule? upcomingSchedule;
    for (final schedule in irrigation.schedules) {
      if (!schedule.enabled) continue;
      final scheduleTimeInMinutes = schedule.startTime.hour * 60 + schedule.startTime.minute;
      final currentTimeInMinutes = now.hour * 60 + now.minute;
      if (scheduleTimeInMinutes >= currentTimeInMinutes) {
        upcomingSchedule = schedule;
        break;
      }
    }

    // PRIORITY 5: Upcoming Schedule Later Today
    if (upcomingSchedule != null) {
      final timeStr = upcomingSchedule.formattedStartTime;
      return RecommendationResult(
        type: RecommendationType.upcoming,
        title: '🌱 ${AppTranslations.tr('todaysRecommendation', lang)}',
        message: '${upcomingSchedule.name} (${upcomingSchedule.formattedDuration}) is planned for $timeStr.',
        primaryActionLabel: AppTranslations.tr('viewSchedules', lang),
        onPrimaryAction: () => onNavigate('schedules'),
        targetSchedule: upcomingSchedule,
      );
    }

    // PRIORITY 6: Today's Irrigation Completed
    if (irrigation.todayCompletedCount > 0 && upcomingSchedule == null) {
      return RecommendationResult(
        type: RecommendationType.completed,
        title: '🌱 ${AppTranslations.tr('todaysRecommendation', lang)}',
        message: AppTranslations.tr('recommendationDone', lang).replaceAll('{count}', irrigation.todayTotalSessions.toString()),
      );
    }

    // PRIORITY 7: Default / No Schedule
    return RecommendationResult(
      type: RecommendationType.noSchedule,
      title: '🌱 ${AppTranslations.tr('todaysRecommendation', lang)}',
      message: AppTranslations.tr('noIrrigationScheduled', lang),
      primaryActionLabel: AppTranslations.tr('viewSchedules', lang),
      onPrimaryAction: () => onNavigate('schedules'),
    );
  }
}
