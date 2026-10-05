import 'package:flutter/material.dart';

class IrrigationSchedule {
  final String id;
  final String name;
  final TimeOfDay startTime;
  final Duration duration;
  final bool enabled;

  IrrigationSchedule({
    required this.id,
    required this.name,
    required this.startTime,
    required this.duration,
    this.enabled = true,
  });

  IrrigationSchedule copyWith({
    String? id,
    String? name,
    TimeOfDay? startTime,
    Duration? duration,
    bool? enabled,
  }) {
    return IrrigationSchedule(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startHour': startTime.hour,
      'startMinute': startTime.minute,
      'durationSeconds': duration.inSeconds,
      'enabled': enabled,
    };
  }

  factory IrrigationSchedule.fromJson(Map<String, dynamic> json) {
    return IrrigationSchedule(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime: TimeOfDay(
        hour: json['startHour'] as int,
        minute: json['startMinute'] as int,
      ),
      duration: Duration(seconds: json['durationSeconds'] as int),
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  String get formattedStartTime {
    final hourStr = startTime.hourOfPeriod == 0 ? '12' : startTime.hourOfPeriod.toString().padLeft(2, '0');
    final minuteStr = startTime.minute.toString().padLeft(2, '0');
    final period = startTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hourStr:$minuteStr $period';
  }

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0 && seconds > 0) {
      return '$minutes min $seconds sec';
    } else if (minutes > 0) {
      return '$minutes min';
    } else {
      return '$seconds sec';
    }
  }
}
