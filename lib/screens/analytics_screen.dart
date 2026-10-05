import 'package:flutter/material.dart';
import '../l10n/app_translations.dart';
import '../models/irrigation_session.dart';
import '../services/irrigation_service.dart';
import '../services/settings_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final irrigation = IrrigationService();
    final settings = SettingsService();

    return ListenableBuilder(
      listenable: Listenable.merge([irrigation, settings]),
      builder: (context, _) {
        final lang = settings.language;
        final history = irrigation.history;
        final now = DateTime.now();

        // Calculate Today's metrics
        final todaySessions = history.where((s) =>
            s.startTime.year == now.year &&
            s.startTime.month == now.month &&
            s.startTime.day == now.day).toList();

        final todayCompleted = todaySessions.where((s) => s.status == IrrigationStatus.completed).length;
        final todayMissed = todaySessions.where((s) => s.status == IrrigationStatus.missed).length;
        final todayInterrupted = todaySessions.where((s) => s.status == IrrigationStatus.interrupted).length;
        final todayCancelled = todaySessions.where((s) => s.status == IrrigationStatus.cancelled).length;

        int todayRuntimeSec = 0;
        for (final s in todaySessions) {
          todayRuntimeSec += s.confirmedRuntime.inSeconds;
        }

        // Calculate This Week (Past 7 Days) metrics
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        final weekSessions = history.where((s) => s.startTime.isAfter(sevenDaysAgo)).toList();

        final weekCompleted = weekSessions.where((s) => s.status == IrrigationStatus.completed).length;
        final weekMissed = weekSessions.where((s) => s.status == IrrigationStatus.missed).length;
        final weekInterrupted = weekSessions.where((s) => s.status == IrrigationStatus.interrupted).length;

        int weekRuntimeSec = 0;
        for (final s in weekSessions) {
          weekRuntimeSec += s.confirmedRuntime.inSeconds;
        }

        // Daily runtime for past 7 days breakdown
        final List<int> dailyRuntimesSec = List.filled(7, 0);
        for (int i = 0; i < 7; i++) {
          final targetDay = now.subtract(Duration(days: 6 - i));
          final daySessions = history.where((s) =>
              s.startTime.year == targetDay.year &&
              s.startTime.month == targetDay.month &&
              s.startTime.day == targetDay.day);
          for (final s in daySessions) {
            dailyRuntimesSec[i] += s.confirmedRuntime.inSeconds;
          }
        }
        final maxDailyRuntime = dailyRuntimesSec.reduce((a, b) => a > b ? a : b);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppTranslations.tr('farmAnalytics', lang),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF2E7D32),
            elevation: 2,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // TODAY SECTION
              _buildSectionHeader(context, AppTranslations.tr('today', lang), Icons.today),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      title: AppTranslations.tr('totalSessions', lang),
                      value: todaySessions.length.toString(),
                      icon: Icons.repeat,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      title: AppTranslations.tr('pumpRuntime', lang),
                      value: _formatDuration(todayRuntimeSec),
                      icon: Icons.timer_outlined,
                      color: const Color(0xFF0288D1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusItem(AppTranslations.tr('completed', lang), todayCompleted, const Color(0xFF2E7D32)),
                      _buildStatusItem(AppTranslations.tr('missed', lang), todayMissed, Colors.orange.shade800),
                      _buildStatusItem(AppTranslations.tr('interrupted', lang), todayInterrupted, const Color(0xFFC62828)),
                      _buildStatusItem(AppTranslations.tr('cancelled', lang), todayCancelled, Colors.grey.shade700),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // THIS WEEK SECTION
              _buildSectionHeader(context, AppTranslations.tr('thisWeek', lang), Icons.date_range),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      title: AppTranslations.tr('totalSessions', lang),
                      value: weekSessions.length.toString(),
                      icon: Icons.grid_view,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      title: AppTranslations.tr('pumpRuntime', lang),
                      value: _formatDuration(weekRuntimeSec),
                      icon: Icons.query_builder,
                      color: const Color(0xFF0288D1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusItem(AppTranslations.tr('completed', lang), weekCompleted, const Color(0xFF2E7D32)),
                      _buildStatusItem(AppTranslations.tr('missed', lang), weekMissed, Colors.orange.shade800),
                      _buildStatusItem(AppTranslations.tr('interrupted', lang), weekInterrupted, const Color(0xFFC62828)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // PAST 7 DAYS RUNTIME BREAKDOWN CHART
              _buildSectionHeader(context, 'Daily Pump Runtime (Past 7 Days)', Icons.bar_chart),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pump Runtime Per Day (Minutes)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (index) {
                          final sec = dailyRuntimesSec[index];
                          final mins = (sec / 60).round();
                          final double fraction = maxDailyRuntime > 0 ? (sec / maxDailyRuntime) : 0.0;
                          final dayDate = now.subtract(Duration(days: 6 - index));
                          final dayName = _getDayAbbreviation(dayDate.weekday);

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${mins}m',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 22,
                                height: 100 * (fraction < 0.08 && sec > 0 ? 0.08 : fraction),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                dayName,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Center(
                child: Text(
                  '* Runtime analytics based on confirmed BLE start/stop command history.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0m';
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    if (mins >= 60) {
      final hours = mins ~/ 60;
      final remMins = mins % 60;
      return '${hours}h ${remMins}m';
    }
    if (mins > 0) {
      return '${mins}m ${secs}s';
    }
    return '${secs}s';
  }

  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
