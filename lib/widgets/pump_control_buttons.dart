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
    final actionDesc = turnOn ? "Manually turned ON" : "Manually turned OFF";
    final success = await service.sendCommand(command, actionDescription: actionDesc);

    if (context.mounted) {
      if (success) {
        final statusMessage = turnOn ? "Command '1' (PUMP ON) Sent" : "Command '0' (PUMP OFF) Sent";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(statusMessage),
            backgroundColor: turnOn ? const Color(0xFF2E7D32) : Colors.grey[800],
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(service.lastError ?? 'Failed to send command.'),
            backgroundColor: const Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = BluetoothService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final isConnected = service.connectionState == BtcConnectionState.connected;
        final isBusy = service.isWriteInProgress;
        final canInteract = isConnected && !isBusy;

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                icon: isBusy && service.isPumpOn == false
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.play_arrow_rounded, size: 28),
                label: const Text(
                  'TURN PUMP ON',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canInteract ? const Color(0xFF0288D1) : Colors.grey[400],
                  foregroundColor: Colors.white,
                  elevation: canInteract ? 3 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: canInteract ? () => _handlePumpAction(context, true) : null,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                icon: isBusy && service.isPumpOn == true
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.stop_rounded, size: 28),
                label: const Text(
                  'TURN PUMP OFF / EMERGENCY STOP',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canInteract ? const Color(0xFFC62828) : Colors.grey[400],
                  foregroundColor: Colors.white,
                  elevation: canInteract ? 3 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: canInteract ? () => _handlePumpAction(context, false) : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
