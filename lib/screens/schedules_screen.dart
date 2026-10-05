import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/scheduled_irrigation_card.dart';

class SchedulesScreen extends StatelessWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        title: Text(
          l10n?.schedules.toUpperCase() ?? 'IRRIGATION SCHEDULES',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white, letterSpacing: 1.1),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 2,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const ScheduledIrrigationCard(),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
              color: const Color(0xFFFFF8E1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFFF57F17), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n?.schedules ?? 'Schedule Limitations & Range Info',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFF57F17)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n?.controllerDisconnectedWarning ??
                          '• This is a local Bluetooth-based irrigation controller.\n'
                          '• Schedules execute only when the phone is powered on and within Bluetooth range of the HC-05.\n'
                          '• If Bluetooth is unavailable when a scheduled time arrives, the session will be logged as Missed.',
                      style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
