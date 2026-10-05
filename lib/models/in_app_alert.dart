enum AlertSeverity {
  safety,
  warning,
  success,
  info,
}

class InAppAlert {
  final String id;
  final AlertSeverity severity;
  final String title;
  final String message;
  final String? actionLabel;
  final String? routePayload; // e.g. 'history', 'schedules', 'dashboard'
  final DateTime timestamp;
  bool isDismissed;

  InAppAlert({
    required this.id,
    required this.severity,
    required this.title,
    required this.message,
    this.actionLabel,
    this.routePayload,
    required this.timestamp,
    this.isDismissed = false,
  });
}
