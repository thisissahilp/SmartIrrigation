import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';

class SystemStatusCard extends StatelessWidget {
  const SystemStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final btService = BluetoothService();
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: btService,
      builder: (context, _) {
        final isConnected = btService.connectionState == BtcConnectionState.connected;
        final isGattReady = btService.isGattReady;
        final hc05Available = btService.findPairedHC05() != null;
        final isPumpOn = btService.isPumpOn;
        final isWatchdogActive = btService.isWatchdogActive;
        final timeSinceHb = btService.secondsSinceLastHeartbeat;

        String pumpStateText;
        Color pumpStateColor;

        if (!isConnected) {
          pumpStateText = l10n?.unknownDisconnected ?? 'UNKNOWN (Disconnected)';
          pumpStateColor = Colors.orange.shade800;
        } else if (isPumpOn) {
          pumpStateText = l10n?.onCommanded ?? 'ON (Commanded)';
          pumpStateColor = Colors.lightBlue.shade800;
        } else {
          pumpStateText = l10n?.off ?? 'OFF';
          pumpStateColor = Colors.grey.shade700;
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.system_security_update_good, color: Color(0xFF2E7D32), size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n?.systemAndConnectionStatus ?? 'SYSTEM & CONNECTION STATUS',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Grid Items
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusTile(
                        label: l10n?.bluetooth ?? 'Bluetooth',
                        value: isConnected ? (l10n?.connected ?? 'Connected') : (l10n?.disconnected ?? 'Disconnected'),
                        isOk: isConnected,
                        icon: isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatusTile(
                        label: l10n?.controllerHc05 ?? 'Controller (HC-05)',
                        value: hc05Available ? (l10n?.available ?? 'Available') : (l10n?.unavailable ?? 'Unavailable'),
                        isOk: hc05Available,
                        icon: Icons.memory,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusTile(
                        label: l10n?.gattProtocol ?? 'GATT Protocol',
                        value: isGattReady ? (l10n?.ready ?? 'Ready (FFE0/FFE1)') : (l10n?.notReady ?? 'Not Ready'),
                        isOk: isGattReady,
                        icon: Icons.swap_horiz,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatusTile(
                        label: l10n?.watchdogSafety ?? 'Watchdog Safety',
                        value: isWatchdogActive ? (l10n?.activePulse ?? 'Active (500ms pulse)') : (l10n?.inactive ?? 'Inactive'),
                        isOk: isWatchdogActive,
                        icon: isWatchdogActive ? Icons.shield : Icons.shield_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Command State & Heartbeat Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(l10n?.pumpCommandState ?? 'Pump command state:', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              pumpStateText,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: pumpStateColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(l10n?.lastHeartbeat ?? 'Last Heartbeat ("H"):', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              timeSinceHb != null ? (l10n?.secAgo(timeSinceHb) ?? '$timeSinceHb sec ago') : (l10n?.na ?? 'N/A'),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Range Warning Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isConnected ? const Color(0xFFE8F5E9) : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isConnected ? const Color(0xFFA5D6A7) : Colors.orange.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isConnected ? Icons.info_outline : Icons.warning_amber_rounded,
                        color: isConnected ? const Color(0xFF2E7D32) : Colors.orange.shade900,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isConnected
                              ? (l10n?.controllerConnectedWarning ?? 'Controller connected via Bluetooth. Stay within reliable Bluetooth range.')
                              : (l10n?.controllerDisconnectedWarning ?? 'Controller disconnected. Move closer to the controller to reconnect.'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isConnected ? const Color(0xFF1B5E20) : Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n?.hardwareDisclaimer ?? '* Pump command state shown. Physical motor confirmation requires additional hardware feedback sensors.',
                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusTile({
    required String label,
    required String value,
    required bool isOk,
    required IconData icon,
  }) {
    final color = isOk ? const Color(0xFF2E7D32) : Colors.orange.shade800;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
