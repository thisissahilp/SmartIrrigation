import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/irrigation_session.dart';

class InterruptionAlertDialog extends StatelessWidget {
  final IrrigationSession session;
  final VoidCallback onDismiss;

  const InterruptionAlertDialog({
    super.key,
    required this.session,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n?.irrigationInterrupted ?? 'Irrigation Interrupted',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.connectionLostTitle ?? 'Bluetooth connection lost.',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            l10n?.watchdogAutoOffMsg ?? 'The Arduino safety watchdog will automatically turn the pump OFF.',
            style: const TextStyle(fontSize: 13, color: Color(0xFFC62828), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n?.lastConfirmedRuntime ?? 'Last confirmed runtime:', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        session.formattedRuntime,
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                if (session.requestedDuration.inSeconds > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n?.scheduledDuration ?? 'Scheduled duration:', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          session.formattedRequestedDuration,
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n?.pumpStateLabel ?? 'Pump state:', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n?.safetyShutdownPending ?? 'SAFETY SHUTDOWN PENDING',
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n?.interruptionReason(session.interruptionReason ?? l10n.watchdogAutoOffMsg) ??
                'Reason: ${session.interruptionReason ?? "Connection lost"}',
            style: TextStyle(fontSize: 12, color: Colors.red.shade900, fontStyle: FontStyle.italic),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            onDismiss();
            Navigator.pop(context);
          },
          child: Text(l10n?.understand ?? 'Understand'),
        ),
      ],
    );
  }
}
