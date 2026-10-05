import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';
import '../services/irrigation_service.dart';

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

  String _formatTime(int totalSeconds) {
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
        final isPumpOn = isConnected && btService.isPumpOn;
        final activeState = irrigationService.activeState;
        final isInterrupted = activeState == ActiveIrrigationState.interruptedUnknown;

        // If pump is ON and connected, play animation, otherwise stop it
        if (isPumpOn) {
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
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              children: [
                Text(
                  l10n?.irrigationPump ?? 'IRRIGATION PUMP',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Animated Pump Icon
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isInterrupted
                              ? Colors.orange.withValues(alpha: 0.15)
                              : (isPumpOn
                                  ? Colors.lightBlue.withValues(alpha: 0.15)
                                  : Colors.grey.withValues(alpha: 0.1)),
                          boxShadow: isPumpOn
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
                      if (isPumpOn)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Stack(
                              children: List.generate(3, (index) {
                                final progress = (_animationController.value + (index / 3)) % 1.0;
                                final opacity = (1.0 - progress).clamp(0.0, 1.0);
                                final size = 20.0 + (progress * 15.0);
                                final yOffset = -35.0 + (progress * 70.0);

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
                      else if (isInterrupted)
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 60,
                          color: Colors.orange[800],
                        )
                      else
                        Icon(
                          Icons.water_drop,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      Icon(
                        Icons.local_activity_outlined,
                        size: 36,
                        color: isInterrupted
                            ? Colors.orange[800]
                            : (isPumpOn ? Colors.lightBlue[800] : Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Main Pump Status Text
                if (isInterrupted) ...[
                  Text(
                    '⚠️ ${l10n?.unknownDisconnected ?? "UNKNOWN STATE"}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n?.controllerDisconnectedWarning ?? 'Bluetooth Connection Lost While Pump Was ON',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else if (isPumpOn) ...[
                  Text(
                    '🟢 ${l10n?.pumpIsRunning ?? "PUMP IS RUNNING"}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.lightBlue[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getIrrigationSourceText(context, irrigationService),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.lightBlue[900],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  Text(
                    '⚪ ${l10n?.pumpIsOff ?? "PUMP IS OFF"}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    !isConnected
                        ? (l10n?.controllerDisconnectedWarning ?? 'Bluetooth disconnected — pump status unavailable')
                        : (l10n?.pumpIsOff ?? 'Pump is currently stopped'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: !isConnected ? Colors.red[700] : Colors.grey[600],
                      fontStyle: FontStyle.italic,
                      fontWeight: !isConnected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],

                // Active Session Timers (Elapsed & Remaining)
                if (isPumpOn && irrigationService.isIrrigationActive) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.lightBlue.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Elapsed',
                              style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _formatTime(irrigationService.activeElapsedSeconds),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0288D1),
                              ),
                            ),
                          ],
                        ),
                        if (irrigationService.activeState == ActiveIrrigationState.timer ||
                            irrigationService.activeState == ActiveIrrigationState.scheduled) ...[
                          Container(height: 24, width: 1, color: Colors.lightBlue.shade200),
                          Column(
                            children: [
                              const Text(
                                'Remaining',
                                style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _formatTime(irrigationService.activeRemainingSeconds),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getIrrigationSourceText(BuildContext context, IrrigationService service) {
    final l10n = AppLocalizations.of(context);
    switch (service.activeState) {
      case ActiveIrrigationState.manual:
        return l10n?.manual ?? 'Manual Control';
      case ActiveIrrigationState.timer:
        return l10n?.timer ?? 'Custom Timer';
      case ActiveIrrigationState.scheduled:
        return service.activeSession?.scheduleName ?? (l10n?.scheduled ?? 'Scheduled Irrigation');
      default:
        return l10n?.manual ?? 'App Control';
    }
  }
}
