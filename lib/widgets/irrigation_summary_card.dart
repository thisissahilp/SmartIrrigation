import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/irrigation_service.dart';

class IrrigationSummaryCard extends StatelessWidget {
  const IrrigationSummaryCard({super.key});

  String _formatDuration(AppLocalizations? l10n, Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final minLabel = l10n?.mins ?? 'min';
    final secLabel = l10n?.secs ?? 'sec';

    if (minutes > 0 && seconds > 0) {
      return '$minutes $minLabel $seconds $secLabel';
    } else if (minutes > 0) {
      return '$minutes $minLabel';
    } else {
      return '$seconds $secLabel';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final service = IrrigationService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final totalSessions = service.todayTotalSessions;
        final completed = service.todayCompletedCount;
        final interrupted = service.todayInterruptedCount;
        final missed = service.todayMissedCount;
        final runtime = service.todayTotalConfirmedRuntime;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.today, color: Color(0xFF2E7D32), size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n?.todaysSummary ?? "TODAY'S IRRIGATION SUMMARY",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Metrics Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        label: l10n?.totalSessions ?? 'Total Sessions',
                        value: '$totalSessions',
                        color: Colors.blue.shade700,
                        icon: Icons.list_alt,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricTile(
                        label: l10n?.completed ?? 'Completed',
                        value: '$completed',
                        color: Colors.green.shade700,
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        label: l10n?.interrupted ?? 'Interrupted',
                        value: '$interrupted',
                        color: Colors.orange.shade800,
                        icon: Icons.warning_amber_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricTile(
                        label: l10n?.missed ?? 'Missed',
                        value: '$missed',
                        color: Colors.red.shade700,
                        icon: Icons.highlight_off,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Total Confirmed Runtime Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFA5D6A7)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Color(0xFF2E7D32), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l10n?.confirmedRuntime ?? 'Confirmed Runtime:',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _formatDuration(l10n, runtime),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Note
                Text(
                  l10n?.runtimeDisclaimer ??
                      '* Confirmed/estimated runtime based on Bluetooth commands and connection timestamps, not physical sensors.',
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
