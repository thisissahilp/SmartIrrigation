import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/irrigation_schedule.dart';
import '../services/irrigation_service.dart';
import 'add_edit_schedule_dialog.dart';

class ScheduledIrrigationCard extends StatelessWidget {
  const ScheduledIrrigationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final irrigationService = IrrigationService();

    return ListenableBuilder(
      listenable: irrigationService,
      builder: (context, _) {
        final schedules = irrigationService.schedules;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule, color: Color(0xFF2E7D32), size: 22),
                        const SizedBox(width: 8),
                        Text(
                          l10n?.scheduledIrrigationTitle ?? 'SCHEDULED IRRIGATION',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Color(0xFF2E7D32), size: 26),
                      tooltip: l10n?.addSchedule ?? 'Add Schedule',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AddEditScheduleDialog(
                            onSave: (newSched) {
                              irrigationService.addSchedule(newSched);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (schedules.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 36, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          l10n?.noActiveSchedules ?? 'No active irrigation schedules.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(l10n?.addSchedule ?? 'Add Schedule'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AddEditScheduleDialog(
                                onSave: (newSched) {
                                  irrigationService.addSchedule(newSched);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: schedules.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      return _buildScheduleItem(context, schedule, irrigationService);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleItem(
    BuildContext context,
    IrrigationSchedule schedule,
    IrrigationService service,
  ) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: schedule.enabled ? const Color(0xFFE8F5E9) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: schedule.enabled ? const Color(0xFFA5D6A7) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: schedule.enabled ? const Color(0xFF2E7D32) : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.alarm, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getLocalizedScheduleName(l10n, schedule.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: schedule.enabled ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text(
                      schedule.formattedStartTime,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: schedule.enabled ? const Color(0xFF2E7D32) : Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '• ${_getFormattedDuration(l10n, schedule.duration)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: schedule.enabled ? Colors.black54 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.black54),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            tooltip: l10n?.editSchedule ?? 'Edit Schedule',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AddEditScheduleDialog(
                  schedule: schedule,
                  onSave: (updatedSched) {
                    service.updateSchedule(updatedSched);
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            tooltip: l10n?.deleteSchedule ?? 'Delete Schedule',
            onPressed: () {
              service.deleteSchedule(schedule.id);
            },
          ),
          const SizedBox(width: 4),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: schedule.enabled,
              activeThumbColor: const Color(0xFF2E7D32),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (val) {
                service.toggleSchedule(schedule.id, val);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedScheduleName(AppLocalizations? l10n, String name) {
    if (name.contains('Morning')) return l10n?.morningIrrigation ?? name;
    if (name.contains('Evening')) return l10n?.eveningIrrigation ?? name;
    if (name.contains('Afternoon')) return l10n?.afternoonIrrigation ?? name;
    return name;
  }

  String _getFormattedDuration(AppLocalizations? l10n, Duration duration) {
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
}
