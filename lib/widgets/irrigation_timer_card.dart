import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';
import '../services/irrigation_service.dart';

class TimerPreset {
  final String label;
  final int totalSeconds;
  const TimerPreset(this.label, this.totalSeconds);
}

class IrrigationTimerCard extends StatefulWidget {
  const IrrigationTimerCard({super.key});

  @override
  State<IrrigationTimerCard> createState() => _IrrigationTimerCardState();
}

class _IrrigationTimerCardState extends State<IrrigationTimerCard> {
  final BluetoothService _bluetoothService = BluetoothService();
  final IrrigationService _irrigationService = IrrigationService();

  static const List<TimerPreset> _presets = [
    TimerPreset('5 SEC', 5),
    TimerPreset('10 SEC', 10),
    TimerPreset('15 SEC', 15),
    TimerPreset('30 SEC', 30),
    TimerPreset('60 SEC', 60),
    TimerPreset('5 MIN', 300),
    TimerPreset('10 MIN', 600),
    TimerPreset('15 MIN', 900),
    TimerPreset('30 MIN', 1800),
  ];

  int _selectedPresetIndex = 1; // Default to 10 SEC
  int _customHours = 0;
  int _customMinutes = 0;
  int _customSeconds = 10;
  bool _isCustomMode = false;

  void _startTimer() async {
    final l10n = AppLocalizations.of(context);
    if (_bluetoothService.connectionState != BtcConnectionState.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.pleaseConnectFirst ?? 'Please connect to HC-05 first to start the timer.'),
          backgroundColor: const Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_irrigationService.isIrrigationActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.irrigationAlreadyRunning ?? 'Irrigation already running.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final totalSecs = _isCustomMode
        ? (_customHours * 3600 + _customMinutes * 60 + _customSeconds)
        : _presets[_selectedPresetIndex].totalSeconds;

    if (totalSecs <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.durationGreaterThanZero ?? 'Please set a valid timer duration greater than 0 seconds.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final durationLabel = _isCustomMode
        ? '${_customHours > 0 ? '${_customHours}h ' : ''}${_customMinutes > 0 ? '${_customMinutes}m ' : ''}${_customSeconds}s'
        : _presets[_selectedPresetIndex].label;

    final success = await _irrigationService.startTimerIrrigation(Duration(seconds: totalSecs));

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.timerStarted(durationLabel) ?? 'Irrigation Timer Started ($durationLabel)'),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_bluetoothService.lastError ?? (l10n?.failedToSend ?? 'Failed to start timer.')),
            backgroundColor: const Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _stopTimer() async {
    final l10n = AppLocalizations.of(context);
    await _irrigationService.cancelTimerIrrigation();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.timerCancelled ?? 'Timer cancelled — Pump turned OFF.'),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    return '$hStr:$mStr:$sStr';
  }

  void _showCustomTimerDialog() {
    final l10n = AppLocalizations.of(context);
    int tempH = _customHours;
    int tempM = _customMinutes;
    int tempS = _customSeconds;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final formattedStr = '${tempH.toString().padLeft(2, '0')}:${tempM.toString().padLeft(2, '0')}:${tempS.toString().padLeft(2, '0')}';
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(l10n?.customTimer ?? 'Custom Irrigation Timer', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(l10n?.hours ?? 'Hours', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                          DropdownButton<int>(
                            value: tempH,
                            items: List.generate(24, (i) => i).map((h) {
                              return DropdownMenuItem(value: h, child: Text(h.toString().padLeft(2, '0')));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => tempH = val);
                            },
                          ),
                        ],
                      ),
                      const Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Column(
                        children: [
                          Text(l10n?.minutes ?? 'Minutes', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                          DropdownButton<int>(
                            value: tempM,
                            items: List.generate(60, (i) => i).map((m) {
                              return DropdownMenuItem(value: m, child: Text(m.toString().padLeft(2, '0')));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => tempM = val);
                            },
                          ),
                        ],
                      ),
                      const Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Column(
                        children: [
                          Text(l10n?.seconds ?? 'Seconds', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                          DropdownButton<int>(
                            value: tempS,
                            items: List.generate(60, (i) => i).map((s) {
                              return DropdownMenuItem(value: s, child: Text(s.toString().padLeft(2, '0')));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => tempS = val);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n?.setDuration(formattedStr) ?? 'Set Duration: $formattedStr',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: Text(l10n?.cancel ?? 'CANCEL'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final total = tempH * 3600 + tempM * 60 + tempS;
                    if (total <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n?.durationGreaterThanZero ?? 'Total duration must be greater than 0 seconds.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _customHours = tempH;
                      _customMinutes = tempM;
                      _customSeconds = tempS;
                      _isCustomMode = true;
                    });
                    Navigator.pop(dialogCtx);
                  },
                  child: Text(l10n?.setTimer ?? 'SET TIMER'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([_bluetoothService, _irrigationService]),
      builder: (context, _) {
        final isConnected = _bluetoothService.connectionState == BtcConnectionState.connected;
        final isTimerRunning = _irrigationService.activeState == ActiveIrrigationState.timer;
        final remainingSeconds = _irrigationService.activeRemainingSeconds;

        return Card(
          elevation: 4,
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
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Color(0xFF2E7D32),
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n?.quickTimer ?? 'IRRIGATION TIMER',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!isTimerRunning) ...[
                  Text(
                    '${l10n?.quickTimer ?? "Timer"} Presets:',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...List.generate(_presets.length, (index) {
                        final preset = _presets[index];
                        final isSelected = !_isCustomMode && _selectedPresetIndex == index;
                        final label = preset.totalSeconds < 60
                            ? (l10n?.timerPresetSec(preset.totalSeconds) ?? preset.label)
                            : (l10n?.timerPresetMin(preset.totalSeconds ~/ 60) ?? preset.label);

                        return ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          selectedColor: const Color(0xFFE8F5E9),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPresetIndex = index;
                                _isCustomMode = false;
                              });
                            }
                          },
                        );
                      }),
                      ChoiceChip(
                        label: Text(_isCustomMode
                            ? 'Custom (${_formatTime(_customHours * 3600 + _customMinutes * 60 + _customSeconds)})'
                            : 'Custom...'),
                        selected: _isCustomMode,
                        selectedColor: const Color(0xFFE8F5E9),
                        labelStyle: TextStyle(
                          color: _isCustomMode ? const Color(0xFF2E7D32) : Colors.black87,
                          fontWeight: _isCustomMode ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (selected) {
                          _showCustomTimerDialog();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_outline),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isConnected ? _startTimer : null,
                      label: Text(
                        l10n?.startTimer ?? 'START TIMER',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _formatTime(remainingSeconds),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: Color(0xFF0288D1),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.circle, color: Color(0xFF2E7D32), size: 12),
                            const SizedBox(width: 6),
                            Text(
                              l10n?.pumpIsRunning ?? 'Timer Running',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.stop_circle_outlined),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC62828),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _stopTimer,
                            label: Text(
                              l10n?.stopTimer ?? 'STOP TIMER',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
