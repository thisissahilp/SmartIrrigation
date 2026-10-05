import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/irrigation_schedule.dart';

class AddEditScheduleDialog extends StatefulWidget {
  final IrrigationSchedule? schedule;
  final Function(IrrigationSchedule schedule) onSave;

  const AddEditScheduleDialog({
    super.key,
    this.schedule,
    required this.onSave,
  });

  @override
  State<AddEditScheduleDialog> createState() => _AddEditScheduleDialogState();
}

class _AddEditScheduleDialogState extends State<AddEditScheduleDialog> {
  late TextEditingController _nameController;
  late TimeOfDay _startTime;
  late int _durationMinutes;
  late int _durationSeconds;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.schedule?.name ?? 'Morning Irrigation');
    _startTime = widget.schedule?.startTime ?? const TimeOfDay(hour: 6, minute: 30);
    final totalSec = widget.schedule?.duration.inSeconds ?? 600;
    _durationMinutes = totalSec ~/ 60;
    _durationSeconds = totalSec % 60;
    _enabled = widget.schedule?.enabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.schedule != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(
            isEditing ? Icons.edit_calendar : Icons.add_alarm,
            color: const Color(0xFF2E7D32),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEditing ? (l10n?.editSchedule ?? 'Edit Schedule') : (l10n?.addSchedule ?? 'Add Irrigation Schedule'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Input
            Text(
              l10n?.scheduleName ?? 'Schedule Name',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: l10n?.scheduleNameHint ?? 'e.g. Morning Irrigation',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Start Time Picker
            Text(
              l10n?.startTime ?? 'Start Time',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: _selectTime,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTimeOfDay(_startTime),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.access_time, color: Color(0xFF2E7D32)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Duration Pickers
            Text(
              l10n?.duration ?? 'Duration',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _durationMinutes,
                    decoration: InputDecoration(
                      labelText: l10n?.minutes ?? 'Minutes',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: List.generate(61, (i) => i).map((m) {
                      return DropdownMenuItem<int>(
                        value: m,
                        child: Text('$m ${l10n?.mins ?? "min"}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _durationMinutes = val);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _durationSeconds,
                    decoration: InputDecoration(
                      labelText: l10n?.seconds ?? 'Seconds',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: List.generate(60, (i) => i).map((s) {
                      return DropdownMenuItem<int>(
                        value: s,
                        child: Text('$s ${l10n?.secs ?? "sec"}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _durationSeconds = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Enabled Switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n?.enableSchedule ?? 'Enable Schedule',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              activeThumbColor: const Color(0xFF2E7D32),
              value: _enabled,
              onChanged: (val) {
                setState(() => _enabled = val);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n?.cancel ?? 'Cancel', style: const TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;

            final totalSeconds = (_durationMinutes * 60) + _durationSeconds;
            if (totalSeconds <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n?.durationGreaterThanZero ?? 'Duration must be greater than 0')),
              );
              return;
            }

            final newSchedule = IrrigationSchedule(
              id: widget.schedule?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
              startTime: _startTime,
              duration: Duration(seconds: totalSeconds),
              enabled: _enabled,
            );

            widget.onSave(newSchedule);
            Navigator.pop(context);
          },
          child: Text(l10n?.saveSchedule ?? 'Save Schedule'),
        ),
      ],
    );
  }
}
