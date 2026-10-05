import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';
import '../services/irrigation_service.dart';

class PumpControlButtons extends StatelessWidget {
  const PumpControlButtons({super.key});

  void _handlePumpAction(BuildContext context, bool turnOn) async {
    final btService = BluetoothService();
    final irrigationService = IrrigationService();
    final l10n = AppLocalizations.of(context);

    if (btService.connectionState != BtcConnectionState.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.pleaseConnectFirst ?? 'Bluetooth is not connected. Tap CONNECT DEVICE above.',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (turnOn) {
      if (irrigationService.isIrrigationActive) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.irrigationAlreadyRunning ?? 'Irrigation already running.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final success = await irrigationService.startManualIrrigation();
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n?.command1Sent ?? "Command '1' (PUMP ON) Sent"),
              backgroundColor: const Color(0xFF2E7D32),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(btService.lastError ?? (l10n?.failedToSend ?? 'Failed to send PUMP ON command.')),
              backgroundColor: const Color(0xFFC62828),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else {
      // TURN PUMP OFF: Force sending ASCII '0' to Arduino via BLE GATT
      final success = await btService.sendCommand('0', actionDescription: 'PUMP OFF requested');
      await irrigationService.stopManualIrrigation();

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n?.command0Sent ?? "Command '0' (PUMP OFF) Sent"),
              backgroundColor: Colors.grey[800],
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(btService.lastError ?? (l10n?.failedToSend ?? 'Failed to send PUMP OFF command.')),
              backgroundColor: const Color(0xFFC62828),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final btService = BluetoothService();
    final irrigationService = IrrigationService();
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([btService, irrigationService]),
      builder: (context, _) {
        final isConnected = btService.connectionState == BtcConnectionState.connected;
        final isBusy = btService.isWriteInProgress;

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                icon: isBusy && btService.isPumpOn == false
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.play_arrow_rounded, size: 28),
                label: Text(
                  l10n?.turnPumpOn ?? 'TURN PUMP ON',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isConnected ? const Color(0xFF0288D1) : Colors.grey[500],
                  foregroundColor: Colors.white,
                  elevation: isConnected ? 3 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _handlePumpAction(context, true),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                icon: isBusy && btService.isPumpOn == true
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.stop_rounded, size: 28),
                label: Text(
                  l10n?.turnPumpOff ?? 'TURN PUMP OFF',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isConnected ? const Color(0xFFC62828) : Colors.grey[600],
                  foregroundColor: Colors.white,
                  elevation: isConnected ? 3 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _handlePumpAction(context, false),
              ),
            ),
          ],
        );
      },
    );
  }
}
