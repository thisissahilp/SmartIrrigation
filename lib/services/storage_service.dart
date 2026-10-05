// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/irrigation_schedule.dart';
import '../models/irrigation_session.dart';

class StorageService {
  static const String _keySchedules = 'smart_farm_schedules';
  static const String _keyHistory = 'smart_farm_history';

  // Singleton instance
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  /// Save schedules to SharedPreferences
  Future<bool> saveSchedules(List<IrrigationSchedule> schedules) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = schedules.map((s) => s.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_keySchedules, jsonString);
    } catch (e) {
      print('StorageService.saveSchedules error: $e');
      return false;
    }
  }

  /// Load schedules from SharedPreferences
  Future<List<IrrigationSchedule>> loadSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keySchedules);
      if (jsonString == null || jsonString.isEmpty) {
        return _getDefaultSchedules();
      }
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => IrrigationSchedule.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('StorageService.loadSchedules error: $e');
      return _getDefaultSchedules();
    }
  }

  List<IrrigationSchedule> _getDefaultSchedules() {
    return [
      IrrigationSchedule(
        id: 'default_morning',
        name: 'Morning Irrigation',
        startTime: const TimeOfDay(hour: 6, minute: 30),
        duration: const Duration(minutes: 10),
        enabled: true,
      ),
      IrrigationSchedule(
        id: 'default_evening',
        name: 'Evening Irrigation',
        startTime: const TimeOfDay(hour: 18, minute: 30),
        duration: const Duration(minutes: 15),
        enabled: false,
      ),
    ];
  }

  /// Save history sessions to SharedPreferences
  Future<bool> saveHistory(List<IrrigationSession> sessions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = sessions.map((s) => s.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_keyHistory, jsonString);
    } catch (e) {
      print('StorageService.saveHistory error: $e');
      return false;
    }
  }

  /// Load history sessions from SharedPreferences
  Future<List<IrrigationSession>> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyHistory);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => IrrigationSession.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('StorageService.loadHistory error: $e');
      return [];
    }
  }

  /// Clear history
  Future<bool> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_keyHistory);
    } catch (e) {
      print('StorageService.clearHistory error: $e');
      return false;
    }
  }
}
