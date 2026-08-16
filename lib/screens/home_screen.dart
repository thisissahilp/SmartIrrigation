import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../widgets/bluetooth_status_card.dart';
import '../widgets/pump_status_card.dart';
import '../widgets/pump_control_buttons.dart';
import '../widgets/irrigation_timer_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BluetoothService();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SMART FARM',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            Text(
              'Wireless Irrigation Controller',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: service,
        builder: (context, _) {
          final isConnected = service.connectionState == BtcConnectionState.connected;
          final isPumpOn = service.isPumpOn;

          return Column(
            children: [
              // Prominent warning if connection lost but pump was ON
              if (isPumpOn && !isConnected)
                Container(
                  width: double.infinity,
                  color: const Color(0xFFC62828),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Bluetooth connection lost! Pump status cannot be verified.',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Error messages snackbar/banner
              if (service.lastError != null)
                Container(
                  width: double.infinity,
                  color: Colors.orange[800],
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.lastError!,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: () => service.clearError(),
                      ),
                    ],
                  ),
                ),

              // Main content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const BluetoothStatusCard(),
                    const SizedBox(height: 16),
                    const PumpStatusCard(),
                    const SizedBox(height: 16),
                    const PumpControlButtons(),
                    const SizedBox(height: 16),
                    const IrrigationTimerCard(),
                    const SizedBox(height: 16),
                    
                    // Bottom status display
                    if (service.lastCommandStatus != null)
                      Card(
                        elevation: 1,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status: ${service.lastCommandStatus}',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => service.clearCommandStatus(),
                                child: const Text(
                                  'Clear',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Smart Farm Project'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'College Prototype Irrigation System',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Architecture:'),
            Text('Mobile App → HC-05 Bluetooth → Arduino → Relay → Pump'),
            SizedBox(height: 12),
            Text('Command Protocol:'),
            Text('• "1" -> Turn pump ON'),
            Text('• "0" -> Turn pump OFF'),
            SizedBox(height: 8),
            Text('Expected responses:'),
            Text('• "PUMP ON"'),
            Text('• "PUMP OFF"'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
