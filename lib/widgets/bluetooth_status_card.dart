import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../screens/bluetooth_devices_screen.dart';

class BluetoothStatusCard extends StatelessWidget {
  const BluetoothStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BluetoothService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final isConnected = service.connectionState == BtcConnectionState.connected;
        final isConnecting = service.connectionState == BtcConnectionState.connecting;
        final deviceName = service.connectedDeviceName ?? "None";

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.bluetooth,
                          color: Color(0xFF2E7D32),
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Bluetooth Connection',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    _buildStatusPill(service.connectionState),
                  ],
                ),
                const SizedBox(height: 16),
                if (isConnected) ...[
                  Row(
                    children: [
                      const Text(
                        'Device: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        deviceName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const Text(
                    'Ensure HC-05 module is powered and paired on your Android device before connecting.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
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
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            isConnected ? 'DISCONNECT' : 'CONNECT DEVICE',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusPill(BtcConnectionState state) {
    String text;
    Color color;
    Color textColor;

    switch (state) {
      case BtcConnectionState.connected:
        text = '🟢 Connected';
        color = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      case BtcConnectionState.connecting:
        text = '🟡 Connecting';
        color = const Color(0xFFFFFDE7);
        textColor = const Color(0xFFFBC02D);
        break;
      case BtcConnectionState.disconnected:
      default:
        text = '🔴 Not Connected';
        color = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
