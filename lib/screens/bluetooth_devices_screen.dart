import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    final title = getDeviceTitle(device);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n?.connectingTo(title, device.address) ?? 'Connecting to $title (${device.address})...'),
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
            content: Text(_bluetoothService.lastError ?? (l10n?.failedToSend ?? 'Connection failed.')),
            backgroundColor: const Color(0xFFC62828),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String getDeviceTitle(BtcDevice device) {
    if (device.name != null && device.name!.isNotEmpty) {
      return device.name!;
    }
    return 'Unknown Device';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        title: Text(
          l10n?.discoverBluetoothDevices ?? 'Discover Bluetooth Devices',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
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
                      l10n?.scanning ?? 'Scanning...',
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
                tooltip: l10n?.refreshPairedDevices ?? 'Refresh paired devices',
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
                    Text(
                      l10n?.btPermissionRequired ?? 'Bluetooth permission is required.',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n?.btPermissionDesc ?? 'Bluetooth permission is required to discover and connect to your HC-05 module.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
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
                      child: Text(l10n?.grantPermission ?? 'GRANT PERMISSION'),
                    ),
                  ],
                ),
              ),
            );
          }

          final pairedDevices = _bluetoothService.pairedDevices;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.devices_other, color: Color(0xFF2E7D32)),
                          SizedBox(width: 8),
                          Text(
                            'PAIRED DEVICES',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (pairedDevices.isEmpty)
                        Text(
                          l10n?.noPairedModuleFound ?? 'Ensure HC-05 module is powered and paired on your Android device before connecting.',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pairedDevices.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final device = pairedDevices[index];
                            final isHc05 = device.name?.toUpperCase().contains('HC-05') == true ||
                                device.address == '4D:50:04:EE:89:AA';
                            final isConnected = _bluetoothService.connectionState == BtcConnectionState.connected &&
                                _bluetoothService.findPairedHC05()?.address == device.address;

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                              leading: Icon(
                                isHc05 ? Icons.memory : Icons.bluetooth,
                                color: isHc05 ? const Color(0xFF2E7D32) : Colors.grey,
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      getDeviceTitle(device),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: isHc05 ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (isHc05) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        l10n?.controllerHc05 ?? 'Controller',
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Text(
                                device.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: isConnected
                                  ? OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        side: const BorderSide(color: Color(0xFFC62828)),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => _bluetoothService.disconnect(),
                                      child: Text(
                                        l10n?.disconnectDevice ?? 'DISCONNECT',
                                        style: const TextStyle(color: Color(0xFFC62828), fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        backgroundColor: isHc05 ? const Color(0xFF2E7D32) : Colors.grey.shade700,
                                        foregroundColor: Colors.white,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => _connectToDevice(device),
                                      child: Text(
                                        l10n?.connectDevice ?? 'CONNECT',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
