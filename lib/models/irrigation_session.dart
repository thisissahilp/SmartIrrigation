enum IrrigationSource {
  manual,
  timer,
  scheduled;

  String get displayName {
    switch (this) {
      case IrrigationSource.manual:
        return 'Manual';
      case IrrigationSource.timer:
        return 'Timer';
      case IrrigationSource.scheduled:
        return 'Scheduled';
    }
  }
}

enum IrrigationStatus {
  completed,
  interrupted,
  missed,
  cancelled;

  String get displayName {
    switch (this) {
      case IrrigationStatus.completed:
        return 'Completed';
      case IrrigationStatus.interrupted:
        return 'Interrupted';
      case IrrigationStatus.missed:
        return 'Missed';
      case IrrigationStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class IrrigationSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration requestedDuration;
  final Duration confirmedRuntime;
  final IrrigationSource source;
  final IrrigationStatus status;
  final String? interruptionReason;
  final String? scheduleName;

  IrrigationSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.requestedDuration,
    required this.confirmedRuntime,
    required this.source,
    required this.status,
    this.interruptionReason,
    this.scheduleName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'requestedDurationSeconds': requestedDuration.inSeconds,
      'confirmedRuntimeSeconds': confirmedRuntime.inSeconds,
      'source': source.name,
      'status': status.name,
      'interruptionReason': interruptionReason,
      'scheduleName': scheduleName,
    };
  }

  factory IrrigationSession.fromJson(Map<String, dynamic> json) {
    return IrrigationSession(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      requestedDuration: Duration(seconds: json['requestedDurationSeconds'] as int? ?? 0),
      confirmedRuntime: Duration(seconds: json['confirmedRuntimeSeconds'] as int? ?? 0),
      source: IrrigationSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => IrrigationSource.manual,
      ),
      status: IrrigationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => IrrigationStatus.completed,
      ),
      interruptionReason: json['interruptionReason'] as String?,
      scheduleName: json['scheduleName'] as String?,
    );
  }

  String get formattedRuntime {
    final minutes = confirmedRuntime.inMinutes;
    final seconds = confirmedRuntime.inSeconds % 60;
    if (minutes > 0 && seconds > 0) {
      return '$minutes min $seconds sec';
    } else if (minutes > 0) {
      return '$minutes min';
    } else {
      return '$seconds sec';
    }
  }

  String get formattedRequestedDuration {
    final minutes = requestedDuration.inMinutes;
    final seconds = requestedDuration.inSeconds % 60;
    if (minutes > 0 && seconds > 0) {
      return '$minutes min $seconds sec';
    } else if (minutes > 0) {
      return '$minutes min';
    } else {
      return '$seconds sec';
    }
  }

  String get formattedStartTime {
    final hour = startTime.hour;
    final hourOfPeriod = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final hourStr = hourOfPeriod.toString().padLeft(2, '0');
    final minuteStr = startTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    return '$hourStr:$minuteStr $period';
  }
}
