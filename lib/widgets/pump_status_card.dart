import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';

class PumpStatusCard extends StatefulWidget {
  const PumpStatusCard({super.key});

  @override
  State<PumpStatusCard> createState() => _PumpStatusCardState();
}

class _PumpStatusCardState extends State<PumpStatusCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = BluetoothService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final isConnected = service.connectionState == BtcConnectionState.connected;
        final isOn = isConnected && service.isPumpOn;

        // If pump is ON and connected, play animation, otherwise stop it
        if (isOn) {
          if (!_animationController.isAnimating) {
            _animationController.repeat();
          }
        } else {
          if (_animationController.isAnimating) {
            _animationController.stop();
          }
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
            child: Column(
              children: [
                const Text(
                  'IRRIGATION PUMP',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular Background Glow
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOn
                              ? Colors.lightBlue.withValues(alpha: 0.15)
                              : Colors.grey.withValues(alpha: 0.1),
                          boxShadow: isOn
                              ? [
                                  BoxShadow(
                                    color: Colors.lightBlue.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  )
                                ]
                              : [],
                        ),
                      ),
                      // Animated Flowing Water Drops
                      if (isOn)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Stack(
                              children: List.generate(3, (index) {
                                final progress = (_animationController.value + (index / 3)) % 1.0;
                                final opacity = (1.0 - progress).clamp(0.0, 1.0);
                                final size = 20.0 + (progress * 15.0);
                                final yOffset = -40.0 + (progress * 80.0);

                                return Transform.translate(
                                  offset: Offset(0, yOffset),
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Icon(
                                      Icons.water_drop,
                                      color: Colors.lightBlue[400],
                                      size: size,
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        )
                      else
                        Icon(
                          Icons.water_drop,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                      // Central Pump Icon
                      Icon(
                        Icons.local_activity_outlined,
                        size: 40,
                        color: isOn ? Colors.lightBlue[800] : Colors.grey[600],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isOn ? '🟢 PUMP ON' : '⚪ PUMP OFF',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: isOn ? Colors.lightBlue[800] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  !isConnected
                      ? 'Bluetooth disconnected — pump status unavailable'
                      : (isOn ? 'Water is currently flowing' : 'Pump is stopped'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: !isConnected ? Colors.red[700] : Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    fontWeight: !isConnected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
