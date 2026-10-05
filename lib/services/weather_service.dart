// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';

enum LocationStatus {
  unknown,
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
}

class WeatherService extends ChangeNotifier {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  bool _initialized = false;
  bool get initialized => _initialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  WeatherData? _weatherData;
  WeatherData? get weatherData => _weatherData;

  String? _lastError;
  String? get lastError => _lastError;

  LocationStatus _locationStatus = LocationStatus.unknown;
  LocationStatus get locationStatus => _locationStatus;

  Future<void> init() async {
    if (_initialized) return;

    await _loadCachedWeather();
    await checkPermissionStatus();

    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadCachedWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('cached_weather_data');
      if (cachedJson != null && cachedJson.isNotEmpty) {
        _weatherData = WeatherData.fromJsonString(cachedJson);
        notifyListeners();
      }
    } catch (e) {
      print('WeatherService._loadCachedWeather error: $e');
    }
  }

  Future<void> _saveCachedWeather(WeatherData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_weather_data', data.toJsonString());
    } catch (e) {
      print('WeatherService._saveCachedWeather error: $e');
    }
  }

  Future<LocationStatus> checkPermissionStatus() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationStatus = LocationStatus.serviceDisabled;
        notifyListeners();
        return _locationStatus;
      }

      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        _locationStatus = LocationStatus.denied;
      } else if (perm == LocationPermission.deniedForever) {
        _locationStatus = LocationStatus.permanentlyDenied;
      } else {
        _locationStatus = LocationStatus.granted;
      }
    } catch (e) {
      print('checkPermissionStatus error: $e');
      _locationStatus = LocationStatus.denied;
    }
    notifyListeners();
    return _locationStatus;
  }

  /// Triggers full flow: Loading State -> Check Service -> Request Permission -> Get Position -> Fetch Open-Meteo
  Future<void> enableLocationAndFetchWeather({bool forceRefresh = false}) async {
    if (_isLoading) return;

    print('[WeatherService] enableLocationAndFetchWeather started');
    _isLoading = true;
    _lastError = null;
    notifyListeners(); // IMMEDIATELY update UI to Loading State

    try {
      // 1. Check if device Location Services (GPS) are turned ON
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('[WeatherService] Device Location Service enabled: $serviceEnabled');
      if (!serviceEnabled) {
        _locationStatus = LocationStatus.serviceDisabled;
        _lastError = 'Device location services are disabled.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 2. Check & Request Location Permission
      var perm = await Geolocator.checkPermission();
      print('[WeatherService] Initial permission check: $perm');

      if (perm == LocationPermission.denied) {
        print('[WeatherService] Requesting permission via Geolocator.requestPermission()...');
        perm = await Geolocator.requestPermission();
        print('[WeatherService] Geolocator requestPermission result: $perm');
      }

      if (perm == LocationPermission.denied) {
        print('[WeatherService] Fallback: Requesting via permission_handler...');
        final status = await Permission.location.request();
        print('[WeatherService] permission_handler status: $status');
        if (status.isGranted) {
          perm = LocationPermission.whileInUse;
        } else if (status.isPermanentlyDenied) {
          perm = LocationPermission.deniedForever;
        }
      }

      if (perm == LocationPermission.deniedForever) {
        _locationStatus = LocationStatus.permanentlyDenied;
        _lastError = 'Location permission is disabled for Smart Farm.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (perm != LocationPermission.whileInUse && perm != LocationPermission.always) {
        _locationStatus = LocationStatus.denied;
        _lastError = 'Location permission is required for local weather.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _locationStatus = LocationStatus.granted;

      // 3. Obtain Position Coordinates
      print('[WeatherService] Getting current position...');
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (e) {
        print('[WeatherService] getCurrentPosition timeout/error: $e. Trying getLastKnownPosition...');
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        _lastError = 'Unable to obtain location coordinates.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      print('[WeatherService] Position: lat=${position.latitude}, lon=${position.longitude}');

      // 4. Fetch Weather from Open-Meteo
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?'
        'latitude=${position.latitude}&longitude=${position.longitude}'
        '&current=temperature_2m,apparent_temperature,precipitation,rain,weather_code'
        '&hourly=precipitation_probability,precipitation,rain,weather_code,temperature_2m'
        '&daily=precipitation_probability_max,precipitation_sum,temperature_2m_max,temperature_2m_min'
        '&timezone=auto',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));
      print('[WeatherService] Open-Meteo HTTP Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final current = data['current'] as Map<String, dynamic>? ?? {};
        final hourly = data['hourly'] as Map<String, dynamic>? ?? {};
        final daily = data['daily'] as Map<String, dynamic>? ?? {};

        final temp = (current['temperature_2m'] as num?)?.toDouble() ?? 25.0;
        final apparent = (current['apparent_temperature'] as num?)?.toDouble() ?? temp;
        final precip = (current['precipitation'] as num?)?.toDouble() ?? 0.0;
        final rain = (current['rain'] as num?)?.toDouble() ?? 0.0;
        final code = (current['weather_code'] as num?)?.toInt() ?? 0;

        final dailyMaxProbList = List<int>.from(
          (daily['precipitation_probability_max'] as List?)?.map((e) => (e as num).toInt()) ?? [0],
        );
        final maxProbToday = dailyMaxProbList.isNotEmpty ? dailyMaxProbList.first : 0;

        final dailyPrecipSumList = List<double>.from(
          (daily['precipitation_sum'] as List?)?.map((e) => (e as num).toDouble()) ?? [0.0],
        );
        final expectedRainfallSumToday = dailyPrecipSumList.isNotEmpty ? dailyPrecipSumList.first : 0.0;

        final dailyMaxTempList = List<double>.from(
          (daily['temperature_2m_max'] as List?)?.map((e) => (e as num).toDouble()) ?? [temp],
        );
        final tempMaxToday = dailyMaxTempList.isNotEmpty ? dailyMaxTempList.first : temp;

        final dailyMinTempList = List<double>.from(
          (daily['temperature_2m_min'] as List?)?.map((e) => (e as num).toDouble()) ?? [temp],
        );
        final tempMinToday = dailyMinTempList.isNotEmpty ? dailyMinTempList.first : temp;

        final hourlyProbList = List<int>.from(
          (hourly['precipitation_probability'] as List?)?.map((e) => (e as num).toInt()) ?? [],
        );
        final hourlyPrecipList = List<double>.from(
          (hourly['precipitation'] as List?)?.map((e) => (e as num).toDouble()) ?? [],
        );
        final hourlyTempList = List<double>.from(
          (hourly['temperature_2m'] as List?)?.map((e) => (e as num).toDouble()) ?? [],
        );
        final hourlyCodeList = List<int>.from(
          (hourly['weather_code'] as List?)?.map((e) => (e as num).toInt()) ?? [],
        );
        final hourlyTimesList = List<String>.from(
          (hourly['time'] as List?)?.map((e) => e.toString()) ?? [],
        );

        int next3Prob = 0;
        if (hourlyProbList.isNotEmpty) {
          final currentHour = DateTime.now().hour;
          final futureHours = hourlyProbList.skip(currentHour).take(3).toList();
          if (futureHours.isNotEmpty) {
            next3Prob = futureHours.reduce((a, b) => a > b ? a : b);
          }
        }

        final weather = WeatherData(
          temperature: temp,
          apparentTemperature: apparent,
          precipitation: precip,
          rain: rain,
          weatherCode: code,
          maxRainProbabilityToday: maxProbToday,
          next3HoursRainProbability: next3Prob,
          tempMaxToday: tempMaxToday,
          tempMinToday: tempMinToday,
          expectedRainfallSumToday: expectedRainfallSumToday,
          hourlyRainProbabilities: hourlyProbList,
          hourlyPrecipitation: hourlyPrecipList,
          hourlyTemperatures: hourlyTempList,
          hourlyWeatherCodes: hourlyCodeList,
          hourlyTimes: hourlyTimesList,
          timestamp: DateTime.now(),
          latitude: position.latitude,
          longitude: position.longitude,
          locationName: 'Current Location',
        );

        _weatherData = weather;
        await _saveCachedWeather(weather);
        _lastError = null;
      } else {
        _lastError = 'Weather API HTTP ${response.statusCode}';
      }
    } catch (e) {
      print('[WeatherService] fetchWeather exception: $e');
      _lastError = 'Weather unavailable (offline).';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
