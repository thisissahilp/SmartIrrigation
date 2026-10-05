import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';
import '../services/irrigation_service.dart';

class EmergencyStopButton extends StatelessWidget {
  const EmergencyStopButton({super.key});

  void _executeEmergencyStop(BuildContext context) async {
    final btService = BluetoothService();
    final irrigationService = IrrigationService();
    final l10n = AppLocalizations.of(context);

    final isConnected = btService.connectionState == BtcConnectionState.connected;

    if (!isConnected) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.signal_wifi_off, color: Colors.redAccent, size: 28),
              const SizedBox(width: 10),
              Text(l10n?.bluetoothUnavailable ?? 'Bluetooth Unavailable'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n?.bluetoothUnavailableMsg ??
                    'Bluetooth connection is unavailable. The Arduino safety watchdog will handle pump shutdown after the 2-second timeout.',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Execute stop command via BLE GATT directly
    final success = await btService.sendCommand('0', actionDescription: 'Emergency Stop Executed');
    await irrigationService.stopManualIrrigation();

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.emergencyStopExecuted ?? '🛑 Emergency Stop Executed — Command "0" sent to Pump'),
            backgroundColor: const Color(0xFFC62828),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(btService.lastError ?? (l10n?.failedToSend ?? 'Emergency stop failed.')),
            backgroundColor: const Color(0xFFC62828),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final btService = BluetoothService();
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: btService,
      builder: (context, _) {
        final isBusy = btService.isWriteInProgress;

        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            icon: isBusy
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : const Icon(Icons.error_outline, size: 28, color: Colors.white),
            label: Text(
              l10n?.emergencyStop ?? '🛑 EMERGENCY STOP',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => _executeEmergencyStop(context),
          ),
        );
      },
    );
  }
}
