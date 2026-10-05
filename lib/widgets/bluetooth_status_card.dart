import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';
import '../screens/bluetooth_devices_screen.dart';

class BluetoothStatusCard extends StatelessWidget {
  const BluetoothStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BluetoothService();
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final isConnected = service.connectionState == BtcConnectionState.connected;
        final isConnecting = service.connectionState == BtcConnectionState.connecting;
        final deviceName = service.connectedDeviceName ?? "None";
        final hc05 = service.findPairedHC05();

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.bluetooth,
                      color: Color(0xFF2E7D32),
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n?.bluetoothConnection ?? 'Bluetooth Connection',
                        maxLines: 2,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusPill(context, service.connectionState),
                  ],
                ),
                const SizedBox(height: 12),
                if (isConnected) ...[
                  Row(
                    children: [
                      const Text(
                        'Device: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          deviceName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    hc05 != null
                        ? (l10n?.pairedModuleFound(getDeviceTitle(hc05), hc05.address) ??
                            'Paired module found: ${getDeviceTitle(hc05)} (${hc05.address}). Tap Connect below.')
                        : (l10n?.noPairedModuleFound ??
                            'Ensure HC-05 module is powered and paired on your Android device before connecting.'),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isConnected ? Colors.red[800] : const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isConnecting
                              ? null
                              : () {
                                  if (isConnected) {
                                    service.disconnect();
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const BluetoothDevicesScreen(),
                                      ),
                                    );
                                  }
                                },
                          child: isConnecting
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      l10n?.connectingButton ?? 'CONNECTING...',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  isConnected
                                      ? (l10n?.disconnectDevice ?? 'DISCONNECT')
                                      : (l10n?.connectDevice ?? 'CONNECT DEVICE'),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusPill(BuildContext context, BtcConnectionState state) {
    final l10n = AppLocalizations.of(context);
    String text;
    Color color;
    Color textColor;

    switch (state) {
      case BtcConnectionState.connected:
        text = '🟢 ${l10n?.connected ?? "Connected"}';
        color = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      case BtcConnectionState.connecting:
        text = '🟡 ${l10n?.connecting ?? "Connecting..."}';
        color = const Color(0xFFFFFDE7);
        textColor = const Color(0xFFFBC02D);
        break;
      case BtcConnectionState.disconnected:
      default:
        text = '🔴 ${l10n?.disconnected ?? "Disconnected"}';
        color = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
