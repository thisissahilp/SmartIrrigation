import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/in_app_alert.dart';
import '../services/notification_service.dart';

class InAppAlertBanner extends StatelessWidget {
  final Function(String route)? onNavigate;

  const InAppAlertBanner({
    super.key,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final notifService = NotificationService();
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: notifService,
      builder: (context, _) {
        final alerts = notifService.activeAlerts;
        if (alerts.isEmpty) return const SizedBox.shrink();

        final alert = alerts.first; // Show top active alert

        Color bgColor;
        Color borderColor;
        Color textColor;
        IconData iconData;

        switch (alert.severity) {
          case AlertSeverity.safety:
            bgColor = const Color(0xFFC62828);
            borderColor = const Color(0xFFB71C1C);
            textColor = Colors.white;
            iconData = Icons.warning_amber_rounded;
            break;
          case AlertSeverity.warning:
            bgColor = Colors.orange.shade800;
            borderColor = Colors.orange.shade900;
            textColor = Colors.white;
            iconData = Icons.warning_amber_rounded;
            break;
          case AlertSeverity.success:
            bgColor = const Color(0xFF2E7D32);
            borderColor = const Color(0xFF1B5E20);
            textColor = Colors.white;
            iconData = Icons.check_circle_outline;
            break;
          case AlertSeverity.info:
            bgColor = const Color(0xFF0288D1);
            borderColor = const Color(0xFF01579B);
            textColor = Colors.white;
            iconData = Icons.info_outline;
            break;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(iconData, color: textColor, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.title,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            alert.message,
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.95),
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      color: textColor.withValues(alpha: 0.9),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: l10n?.dismiss ?? 'Dismiss',
                      onPressed: () {
                        notifService.dismissAlert(alert.id);
                      },
                    ),
                  ],
                ),
                if (alert.actionLabel != null && alert.routePayload != null) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textColor,
                        side: BorderSide(color: textColor.withValues(alpha: 0.6)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        if (onNavigate != null && alert.routePayload != null) {
                          onNavigate!(alert.routePayload!);
                        }
                      },
                      child: Text(
                        alert.actionLabel!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
