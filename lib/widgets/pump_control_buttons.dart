import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';

class PumpControlButtons extends StatelessWidget {
  const PumpControlButtons({super.key});

  void _handlePumpAction(BuildContext context, bool turnOn) async {
    final service = BluetoothService();

    if (service.connectionState != BtcConnectionState.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please connect to HC-05 first.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final command = turnOn ? "1" : "0";
    await service.sendCommand(command);

    if (context.mounted) {
      final statusMessage = turnOn ? "Command 'ON' Sent" : "Command 'OFF' Sent";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(statusMessage),
          backgroundColor: turnOn ? const Color(0xFF2E7D32) : Colors.grey[800],
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow, size: 28),
            label: const Text(
              'TURN PUMP ON',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0288D1),
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => _handlePumpAction(context, true),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.stop, size: 28),
            label: const Text(
              'TURN PUMP OFF',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => _handlePumpAction(context, false),
          ),
        ),
      ],
    );
  }
}
