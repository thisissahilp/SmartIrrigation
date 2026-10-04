class ActivityLogEntry {
  final DateTime timestamp;
  final String title;
  final String details;

  ActivityLogEntry({
    required this.timestamp,
    required this.title,
    required this.details,
  });

  String get formattedTime {
    final hourInt = timestamp.hour == 0 ? 12 : (timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour);
    final hourStr = hourInt.toString().padLeft(2, '0');
    final minuteStr = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hourStr:$minuteStr $period';
  }
}
