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
      _bluetoothService.startDiscovery();
    }
  }

  @override
  void dispose() {
    _bluetoothService.stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        title: const Text(
          'Pair / Connect HC-05',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          ListenableBuilder(
            listenable: _bluetoothService,
            builder: (context, _) {
              if (_bluetoothService.isScanning) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _bluetoothService.startDiscovery();
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
                    const Icon(Icons.security, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Bluetooth Permissions Required',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please grant Bluetooth permissions to allow searching and connecting to HC-05.',
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
                            _bluetoothService.startDiscovery();
                          }
                        });
                      },
                      child: const Text('Grant Permissions'),
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
                      'Bluetooth is Disabled',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please turn on Bluetooth in your Android settings to find HC-05.',
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

          if (paired.isEmpty && discovered.isEmpty && !_bluetoothService.isScanning) {
            return const Center(
              child: Text('No Bluetooth devices found. Please try refreshing.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (paired.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Text(
                    'Paired Devices',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                      final isHC05 = device.displayName.toUpperCase().contains('HC-05') ||
                          device.displayName.toUpperCase().contains('HC-06');
                      return _buildDeviceTile(device, isHC05);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (discovered.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Text(
                    'Other Available Devices',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                    itemCount: discovered.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final device = discovered[index];
                      final isHC05 = device.displayName.toUpperCase().contains('HC-05') ||
                          device.displayName.toUpperCase().contains('HC-06');
                      return _buildDeviceTile(device, isHC05);
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

  Widget _buildDeviceTile(BtcDevice device, bool isHC05) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isHC05 ? const Color(0xFFE8F5E9) : Colors.grey[200],
        child: Icon(
          Icons.bluetooth,
          color: isHC05 ? const Color(0xFF2E7D32) : Colors.grey[600],
        ),
      ),
      title: Text(
        device.displayName.isNotEmpty ? device.displayName : 'Unknown Device',
        style: TextStyle(
          fontWeight: isHC05 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(device.address),
      trailing: isHC05
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA5D6A7)),
              ),
              child: const Text(
                'HC-05 Module',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: () async {
        _bluetoothService.stopDiscovery();
        
        // Show connecting dialog or just connect and go back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connecting to ${device.displayName}...'),
            duration: const Duration(seconds: 2),
          ),
        );
        
        await _bluetoothService.connect(device);
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
