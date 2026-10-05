import 'dart:convert';
import 'package:flutter/material.dart';
import '../l10n/app_translations.dart';

enum DaySegment {
  morning,   // 6 AM - 12 PM
  afternoon, // 12 PM - 6 PM
  evening,   // 6 PM - 12 AM
  night;     // 12 AM - 6 AM

  String get keyName {
    switch (this) {
      case DaySegment.morning:
        return 'morning';
      case DaySegment.afternoon:
        return 'afternoon';
      case DaySegment.evening:
        return 'evening';
      case DaySegment.night:
        return 'night';
    }
  }
}

class HourlyForecastItem {
  final DateTime time;
  final double temperature;
  final int rainProbability;
  final double precipitation;
  final int weatherCode;

  HourlyForecastItem({
    required this.time,
    required this.temperature,
    required this.rainProbability,
    required this.precipitation,
    required this.weatherCode,
  });

  String getWeatherCondition(AppLanguage lang) {
    if (weatherCode == 0) {
      return AppTranslations.tr('clearSky', lang);
    } else if (weatherCode >= 1 && weatherCode <= 3) {
      return AppTranslations.tr('partlyCloudy', lang);
    } else if ((weatherCode >= 51 && weatherCode <= 67) || (weatherCode >= 80 && weatherCode <= 82)) {
      return AppTranslations.tr('rainy', lang);
    } else if (weatherCode >= 95) {
      return AppTranslations.tr('thunderstorm', lang);
    } else if (weatherCode >= 45 && weatherCode <= 48) {
      return AppTranslations.tr('cloudy', lang);
    }
    return AppTranslations.tr('partlyCloudy', lang);
  }

  IconData get weatherIcon {
    if (weatherCode == 0) {
      return Icons.wb_sunny_outlined;
    } else if (weatherCode >= 1 && weatherCode <= 3) {
      return Icons.wb_cloudy_outlined;
    } else if ((weatherCode >= 51 && weatherCode <= 67) || (weatherCode >= 80 && weatherCode <= 82)) {
      return Icons.grain_outlined;
    } else if (weatherCode >= 95) {
      return Icons.thunderstorm_outlined;
    }
    return Icons.cloud_outlined;
  }

  String get formattedHour {
    final hour = time.hour;
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    return hour > 12 ? '${hour - 12} PM' : '$hour AM';
  }
}

class DaySegmentForecast {
  final DaySegment segment;
  final double temperature;
  final int rainProbability;
  final double precipitation;
  final int weatherCode;

  DaySegmentForecast({
    required this.segment,
    required this.temperature,
    required this.rainProbability,
    required this.precipitation,
    required this.weatherCode,
  });

  IconData get weatherIcon {
    if (weatherCode == 0) return Icons.wb_sunny_outlined;
    if (weatherCode >= 1 && weatherCode <= 3) return Icons.wb_cloudy_outlined;
    if ((weatherCode >= 51 && weatherCode <= 67) || (weatherCode >= 80 && weatherCode <= 82)) return Icons.grain_outlined;
    if (weatherCode >= 95) return Icons.thunderstorm_outlined;
    return Icons.cloud_outlined;
  }
}

class WindowRainInfo {
  final int maxRainProbability;
  final double expectedPrecipitation;
  final int weatherCode;

  WindowRainInfo({
    required this.maxRainProbability,
    required this.expectedPrecipitation,
    required this.weatherCode,
  });
}

class WeatherData {
  final double temperature;
  final double apparentTemperature;
  final double precipitation;
  final double rain;
  final int weatherCode;
  final int maxRainProbabilityToday;
  final int next3HoursRainProbability;
  final double tempMaxToday;
  final double tempMinToday;
  final double expectedRainfallSumToday;
  final List<int> hourlyRainProbabilities;
  final List<double> hourlyPrecipitation;
  final List<double> hourlyTemperatures;
  final List<int> hourlyWeatherCodes;
  final List<String> hourlyTimes;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String locationName;

  WeatherData({
    required this.temperature,
    required this.apparentTemperature,
    required this.precipitation,
    required this.rain,
    required this.weatherCode,
    required this.maxRainProbabilityToday,
    required this.next3HoursRainProbability,
    required this.tempMaxToday,
    required this.tempMinToday,
    required this.expectedRainfallSumToday,
    required this.hourlyRainProbabilities,
    required this.hourlyPrecipitation,
    required this.hourlyTemperatures,
    required this.hourlyWeatherCodes,
    required this.hourlyTimes,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  bool get isStale => DateTime.now().difference(timestamp).inMinutes > 60;

  String getWeatherCondition(AppLanguage lang) {
    if (weatherCode == 0) {
      return AppTranslations.tr('clearSky', lang);
    } else if (weatherCode >= 1 && weatherCode <= 3) {
      return AppTranslations.tr('partlyCloudy', lang);
    } else if ((weatherCode >= 51 && weatherCode <= 67) || (weatherCode >= 80 && weatherCode <= 82)) {
      return AppTranslations.tr('rainy', lang);
    } else if (weatherCode >= 95) {
      return AppTranslations.tr('thunderstorm', lang);
    } else if (weatherCode >= 45 && weatherCode <= 48) {
      return AppTranslations.tr('cloudy', lang);
    }
    return AppTranslations.tr('partlyCloudy', lang);
  }

  IconData get weatherIcon {
    if (weatherCode == 0) {
      return Icons.wb_sunny_outlined;
    } else if (weatherCode >= 1 && weatherCode <= 3) {
      return Icons.wb_cloudy_outlined;
    } else if ((weatherCode >= 51 && weatherCode <= 67) || (weatherCode >= 80 && weatherCode <= 82)) {
      return Icons.grain_outlined;
    } else if (weatherCode >= 95) {
      return Icons.thunderstorm_outlined;
    }
    return Icons.cloud_outlined;
  }

  /// Parses all hourly items
  List<HourlyForecastItem> getHourlyItems() {
    final list = <HourlyForecastItem>[];
    final count = hourlyTimes.length;
    for (int i = 0; i < count; i++) {
      DateTime dt;
      try {
        dt = DateTime.parse(hourlyTimes[i]);
      } catch (_) {
        dt = DateTime.now().add(Duration(hours: i));
      }
      final prob = i < hourlyRainProbabilities.length ? hourlyRainProbabilities[i] : 0;
      final prec = i < hourlyPrecipitation.length ? hourlyPrecipitation[i] : 0.0;
      final temp = i < hourlyTemperatures.length ? hourlyTemperatures[i] : temperature;
      final code = i < hourlyWeatherCodes.length ? hourlyWeatherCodes[i] : weatherCode;

      list.add(HourlyForecastItem(
        time: dt,
        temperature: temp,
        rainProbability: prob,
        precipitation: prec,
        weatherCode: code,
      ));
    }
    return list;
  }

  /// Gets hourly forecast for today (24 hours for current date)
  List<HourlyForecastItem> getTodayHourlyForecast() {
    final all = getHourlyItems();
    final now = DateTime.now();
    final todayItems = all.where((item) =>
      item.time.year == now.year &&
      item.time.month == now.month &&
      item.time.day == now.day
    ).toList();

    if (todayItems.isEmpty && all.isNotEmpty) {
      return all.take(24).toList();
    }
    return todayItems;
  }

  /// Aggregates forecast into Morning (6-12), Afternoon (12-18), Evening (18-24), Night (0-6)
  List<DaySegmentForecast> getDaySegments() {
    final todayHourly = getTodayHourlyForecast();

    List<HourlyForecastItem> getItemsForHours(int startHour, int endHour) {
      return todayHourly.where((item) => item.time.hour >= startHour && item.time.hour < endHour).toList();
    }

    DaySegmentForecast buildSegment(DaySegment segment, int startHour, int endHour) {
      final items = getItemsForHours(startHour, endHour);
      if (items.isEmpty) {
        return DaySegmentForecast(
          segment: segment,
          temperature: temperature,
          rainProbability: maxRainProbabilityToday,
          precipitation: 0.0,
          weatherCode: weatherCode,
        );
      }

      double sumTemp = 0.0;
      int maxProb = 0;
      double sumPrecip = 0.0;
      int maxCode = 0;

      for (final item in items) {
        sumTemp += item.temperature;
        if (item.rainProbability > maxProb) maxProb = item.rainProbability;
        sumPrecip += item.precipitation;
        if (item.weatherCode > maxCode) maxCode = item.weatherCode;
      }

      return DaySegmentForecast(
        segment: segment,
        temperature: sumTemp / items.length,
        rainProbability: maxProb,
        precipitation: sumPrecip,
        weatherCode: maxCode,
      );
    }

    return [
      buildSegment(DaySegment.morning, 6, 12),
      buildSegment(DaySegment.afternoon, 12, 18),
      buildSegment(DaySegment.evening, 18, 24),
      buildSegment(DaySegment.night, 0, 6),
    ];
  }

  /// Calculates rain probability and precipitation around a schedule start time + duration
  WindowRainInfo getRainInfoForScheduleWindow(TimeOfDay startTime, Duration duration) {
    final todayHourly = getTodayHourlyForecast();
    if (todayHourly.isEmpty) {
      return WindowRainInfo(
        maxRainProbability: maxRainProbabilityToday,
        expectedPrecipitation: expectedRainfallSumToday,
        weatherCode: weatherCode,
      );
    }

    final startHour = startTime.hour;
    final endHour = (startHour + (duration.inMinutes / 60).ceil() + 1).clamp(0, 23);

    // Inspect window from 1 hour before start time to end hour
    final windowItems = todayHourly.where((item) =>
      item.time.hour >= (startHour - 1).clamp(0, 23) &&
      item.time.hour <= endHour
    ).toList();

    if (windowItems.isEmpty) {
      // Fall back to exact start hour match or nearest
      final exactMatch = todayHourly.firstWhere(
        (item) => item.time.hour == startHour,
        orElse: () => todayHourly.first,
      );
      return WindowRainInfo(
        maxRainProbability: exactMatch.rainProbability,
        expectedPrecipitation: exactMatch.precipitation,
        weatherCode: exactMatch.weatherCode,
      );
    }

    int maxProb = 0;
    double sumPrecip = 0.0;
    int maxCode = 0;

    for (final item in windowItems) {
      if (item.rainProbability > maxProb) maxProb = item.rainProbability;
      sumPrecip += item.precipitation;
      if (item.weatherCode > maxCode) maxCode = item.weatherCode;
    }

    return WindowRainInfo(
      maxRainProbability: maxProb,
      expectedPrecipitation: sumPrecip,
      weatherCode: maxCode,
    );
  }

  /// Returns sum of precipitation in past N hours from current hour
  double getRecentPrecipitation(int pastHours) {
    final all = getHourlyItems();
    if (all.isEmpty) return precipitation;

    final now = DateTime.now();
    final pastItems = all.where((item) =>
      item.time.isBefore(now) && item.time.isAfter(now.subtract(Duration(hours: pastHours)))
    ).toList();

    double sum = 0.0;
    for (final item in pastItems) {
      sum += item.precipitation;
    }
    return sum;
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'apparentTemperature': apparentTemperature,
      'precipitation': precipitation,
      'rain': rain,
      'weatherCode': weatherCode,
      'maxRainProbabilityToday': maxRainProbabilityToday,
      'next3HoursRainProbability': next3HoursRainProbability,
      'tempMaxToday': tempMaxToday,
      'tempMinToday': tempMinToday,
      'expectedRainfallSumToday': expectedRainfallSumToday,
      'hourlyRainProbabilities': hourlyRainProbabilities,
      'hourlyPrecipitation': hourlyPrecipitation,
      'hourlyTemperatures': hourlyTemperatures,
      'hourlyWeatherCodes': hourlyWeatherCodes,
      'hourlyTimes': hourlyTimes,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
    };
  }

  factory WeatherData.fromJson(Map<String, dynamic> map) {
    return WeatherData(
      temperature: (map['temperature'] as num).toDouble(),
      apparentTemperature: (map['apparentTemperature'] as num).toDouble(),
      precipitation: (map['precipitation'] as num).toDouble(),
      rain: (map['rain'] as num).toDouble(),
      weatherCode: (map['weatherCode'] as num).toInt(),
      maxRainProbabilityToday: (map['maxRainProbabilityToday'] as num).toInt(),
      next3HoursRainProbability: (map['next3HoursRainProbability'] as num).toInt(),
      tempMaxToday: (map['tempMaxToday'] as num?)?.toDouble() ?? (map['temperature'] as num).toDouble(),
      tempMinToday: (map['tempMinToday'] as num?)?.toDouble() ?? (map['temperature'] as num).toDouble(),
      expectedRainfallSumToday: (map['expectedRainfallSumToday'] as num?)?.toDouble() ?? (map['precipitation'] as num).toDouble(),
      hourlyRainProbabilities: List<int>.from(map['hourlyRainProbabilities'] ?? []),
      hourlyPrecipitation: List<double>.from((map['hourlyPrecipitation'] as List?)?.map((e) => (e as num).toDouble()) ?? []),
      hourlyTemperatures: List<double>.from((map['hourlyTemperatures'] as List?)?.map((e) => (e as num).toDouble()) ?? []),
      hourlyWeatherCodes: List<int>.from((map['hourlyWeatherCodes'] as List?)?.map((e) => (e as num).toInt()) ?? []),
      hourlyTimes: List<String>.from(map['hourlyTimes'] ?? []),
      timestamp: DateTime.parse(map['timestamp'] as String),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      locationName: map['locationName'] as String? ?? 'Current Location',
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory WeatherData.fromJsonString(String source) => WeatherData.fromJson(jsonDecode(source));
}
