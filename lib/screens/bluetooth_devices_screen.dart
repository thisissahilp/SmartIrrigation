import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';

class BluetoothDevicesScreen extends StatefulWidget {
  const BluetoothDevicesScreen({super.key});

  @override
  State<BluetoothDevicesScreen> createState() => _BluetoothDevicesScreenState();
}

class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
  final BluetoothService _bluetoothService = BluetoothService();

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    await _bluetoothService.init();
    final hasPermission = await _bluetoothService.requestPermissions();
    if (hasPermission) {
      await _bluetoothService.loadPairedDevices();
    }
  }

  @override
  void dispose() {
    _bluetoothService.stopDiscovery();
    super.dispose();
  }

  Future<void> _connectToDevice(BtcDevice device) async {
    final title = getDeviceTitle(device);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting to $title (${device.address})...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    final success = await _bluetoothService.connect(device);

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_bluetoothService.lastError ?? 'Connection failed.'),
            backgroundColor: const Color(0xFFC62828),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        title: const Text(
          'Discover Bluetooth Devices',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          ListenableBuilder(
            listenable: _bluetoothService,
            builder: (context, _) {
              if (_bluetoothService.isScanning) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Scanning...',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh paired devices',
                onPressed: () async {
                  final hasPermission = await _bluetoothService.requestPermissions();
                  if (hasPermission) {
                    await _bluetoothService.refreshDevices();
                  }
                },
              );
            },
          )
        ],
      ),
      body: ListenableBuilder(
        listenable: _bluetoothService,
        builder: (context, _) {
          if (!_bluetoothService.hasPermission) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.security, size: 64, color: Color(0xFFC62828)),
                    const SizedBox(height: 16),
                    const Text(
                      'Bluetooth permission is required.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Bluetooth permission is required to discover and connect to your HC-05 module.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _bluetoothService.requestPermissions().then((granted) {
                          if (granted) {
                            _bluetoothService.loadPairedDevices();
                          }
                        });
                      },
                      child: const Text('Grant Permission'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!_bluetoothService.isBluetoothOn) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bluetooth_disabled, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text(
                      'Please turn on Bluetooth.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please enable Bluetooth in your Android Settings to connect to HC-05.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          final paired = _bluetoothService.pairedDevices;
          final discovered = _bluetoothService.discoveredDevices;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Notice banner
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bluetooth_connected, color: Colors.green[800], size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Select your HC-05 module below to establish a persistent BLE GATT connection.',
                        style: TextStyle(color: Colors.green[900], fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              if (paired.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Text(
                    'PAIRED BLUETOOTH DEVICES',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paired.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final device = paired[index];
                      return _buildDeviceTile(device, isPaired: true);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (discovered.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    children: [
                      const Text(
                        'NEARBY DEVICES',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_bluetoothService.isScanning)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                          ),
                        ),
                    ],
                  ),
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: discovered.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final device = discovered[index];
                      return _buildDeviceTile(device, isPaired: false);
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildDeviceTile(BtcDevice device, {required bool isPaired}) {
    final isConnecting = _bluetoothService.connectionState == BtcConnectionState.connecting;
    final title = getDeviceTitle(device);
    final titleUpper = title.toUpperCase();
    final isHC05 = titleUpper.contains('HC-05') ||
        titleUpper.contains('HC-06') ||
        titleUpper.contains('HC05') ||
        titleUpper.contains('HC06');

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: isHC05 ? const Color(0xFFE8F5E9) : Colors.grey[200],
        child: Icon(
          Icons.bluetooth,
          color: isHC05 ? const Color(0xFF2E7D32) : Colors.grey[600],
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isHC05 ? FontWeight.bold : FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPaired ? 'Bluetooth LE • Paired' : 'Bluetooth LE • Nearby',
            style: TextStyle(
              fontSize: 12,
              color: isPaired ? const Color(0xFF2E7D32) : Colors.orange[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            device.address,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isHC05 ? const Color(0xFF2E7D32) : Colors.grey[700],
          foregroundColor: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: isConnecting ? null : () => _connectToDevice(device),
        child: Text(
          isPaired ? 'CONNECT' : 'PAIR & CONNECT',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
