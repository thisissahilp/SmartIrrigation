// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_translations.dart';

enum AppThemeMode {
  light;

  ThemeMode get themeMode => ThemeMode.light;

  String get displayName => 'Light Mode';
}

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  bool _initialized = false;
  bool get initialized => _initialized;

  AppThemeMode get themeMode => AppThemeMode.light;

  AppLanguage _language = AppLanguage.english;
  AppLanguage get language => _language;

  Locale get locale {
    switch (_language) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.marathi:
        return const Locale('mr');
      case AppLanguage.hindi:
        return const Locale('hi');
    }
  }

  bool _isFarmerMode = false;
  bool get isFarmerMode => _isFarmerMode;

  String tr(String key) => AppTranslations.tr(key, _language);

  Future<void> init() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      final langIndex = prefs.getInt('app_language') ?? 0;
      if (langIndex >= 0 && langIndex < AppLanguage.values.length) {
        _language = AppLanguage.values[langIndex];
      }

      _isFarmerMode = prefs.getBool('app_farmer_mode') ?? false;
    } catch (e) {
      print('SettingsService.init error: $e');
    }

    _initialized = true;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('app_language', lang.index);
    } catch (e) {
      print('setLanguage error: $e');
    }
  }

  Future<void> setFarmerMode(bool enabled) async {
    _isFarmerMode = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('app_farmer_mode', enabled);
    } catch (e) {
      print('setFarmerMode error: $e');
    }
  }
}
