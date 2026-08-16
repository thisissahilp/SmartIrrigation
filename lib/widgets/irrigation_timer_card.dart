import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';

class IrrigationTimerCard extends StatefulWidget {
  const IrrigationTimerCard({super.key});

  @override
  State<IrrigationTimerCard> createState() => _IrrigationTimerCardState();
}

class _IrrigationTimerCardState extends State<IrrigationTimerCard> {
  final BluetoothService _bluetoothService = BluetoothService();
  
  final List<int> _durations = [1, 2, 5, 10]; // in minutes
  int _selectedDuration = 1; // default to 1 minute
  
  Timer? _countdownTimer;
  int _secondsRemaining = 0;
  bool _isTimerRunning = false;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() async {
    if (_bluetoothService.connectionState != BtcConnectionState.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please connect to HC-05 first to use the timer.'),
          backgroundColor: Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _secondsRemaining = _selectedDuration * 60;
      _isTimerRunning = true;
    });

    // 1. Send "1" (Turn Pump ON)
    await _bluetoothService.sendCommand("1");

    // 2. Start Countdown
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _stopTimer(sendStopCommand: true);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Irrigation Timer Started for $_selectedDuration Minute(s)'),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _stopTimer({bool sendStopCommand = false}) async {
    _countdownTimer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _secondsRemaining = 0;
    });

    if (sendStopCommand) {
      // Send "0" (Turn Pump OFF)
      await _bluetoothService.sendCommand("0");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Timer Finished. Pump turned OFF.'),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Timer Cancelled.'),
            backgroundColor: Colors.grey,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _bluetoothService,
      builder: (context, _) {
        final isConnected = _bluetoothService.connectionState == BtcConnectionState.connected;

        // Auto-stop timer if Bluetooth gets disconnected
        if (!isConnected && _isTimerRunning) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _stopTimer(sendStopCommand: false);
          });
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: Color(0xFF2E7D32),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Irrigation Timer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_isTimerRunning) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Run Pump For:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedDuration,
                            items: _durations.map((duration) {
                              return DropdownMenuItem<int>(
                                value: duration,
                                child: Text('$duration Minute${duration > 1 ? 's' : ''}'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedDuration = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isConnected ? _startTimer : null,
                      child: const Text(
                        'START TIMER',
                        style: TextStyle(
                          fontSize: 16,
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
                          _formatTime(_secondsRemaining),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courier',
                            color: Color(0xFF0288D1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Remaining time until pump is turned off',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFC62828)),
                              foregroundColor: const Color(0xFFC62828),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _stopTimer(sendStopCommand: true),
                            child: const Text(
                              'CANCEL TIMER & STOP PUMP',
                              style: TextStyle(
                                fontSize: 14,
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
