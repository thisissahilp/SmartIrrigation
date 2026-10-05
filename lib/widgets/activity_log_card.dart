import 'package:flutter/material.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';

class ActivityLogCard extends StatelessWidget {
  const ActivityLogCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final service = BluetoothService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final logs = service.activityLogs;

        if (logs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.history_rounded,
                          color: Color(0xFF2E7D32),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n?.activityLog ?? 'Activity Log',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      l10n?.eventsCount(logs.length) ?? '${logs.length} events',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logs.length > 5 ? 5 : logs.length,
                  separatorBuilder: (context, index) => const Divider(height: 8, color: Colors.black12),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    Color iconColor = Colors.grey;
                    IconData iconData = Icons.info_outline;

                    if (log.title.contains('ON')) {
                      iconColor = const Color(0xFF0288D1);
                      iconData = Icons.water_drop;
                    } else if (log.title.contains('OFF') || log.title.contains('Stop')) {
                      iconColor = Colors.grey[700]!;
                      iconData = Icons.power_settings_new;
                    } else if (log.title.contains('Connected')) {
                      iconColor = const Color(0xFF2E7D32);
                      iconData = Icons.bluetooth_connected;
                    } else if (log.title.contains('Disconnect') || log.title.contains('Failed')) {
                      iconColor = const Color(0xFFC62828);
                      iconData = Icons.bluetooth_disabled;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(iconData, size: 18, color: iconColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  log.details,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            log.formattedTime,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
