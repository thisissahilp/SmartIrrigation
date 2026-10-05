import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';

class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  final BluetoothService _btService = BluetoothService();
  bool _isTestingPump = false;
  int _testPumpSecondsRemaining = 0;
  Timer? _testPumpTimer;
  String _testLog = '';

  @override
  void dispose() {
    _testPumpTimer?.cancel();
    super.dispose();
  }

  void _runConnectionTest() async {
    setState(() {
      _testLog = 'Testing connection...\n';
    });

    final mac = _btService.findPairedHC05()?.address ?? '4D:50:04:EE:89:AA';

    setState(() {
      _testLog = '=== BLE CONNECTION DIAGNOSTIC ===\n'
          'MAC: $mac\n'
          'Connection State: ${_btService.connectionState.name.toUpperCase()}\n'
          'GATT Protocol: ${_btService.isGattReady ? "READY" : "NOT READY"}\n'
          'Service FFE0: ${_btService.isGattReady ? "FOUND" : "PENDING"}\n'
          'Characteristic FFE1: ${_btService.isGattReady ? "FOUND" : "PENDING"}\n'
          'Is Watchdog Active: ${_btService.isWatchdogActive}\n'
          'Last Command: ${_btService.lastSentCommand ?? "None"}\n'
          '=================================';
    });
  }

  void _run5SecondPumpTest() {
    final l10n = AppLocalizations.of(context);
    if (_btService.connectionState != BtcConnectionState.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.pleaseConnectFirst ?? 'Please connect to HC-05 first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.build_circle, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Text(l10n?.confirmPumpTestTitle ?? 'Confirm Pump Test'),
          ],
        ),
        content: Text(
          l10n?.confirmPumpTestContent ??
              'This diagnostic will turn the pump ON for exactly 5 seconds and then automatically turn it OFF.\n\nProceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _start5SecondTest();
            },
            child: Text(l10n?.start5sTest ?? 'Start 5s Test'),
          ),
        ],
      ),
    );
  }

  void _start5SecondTest() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isTestingPump = true;
      _testPumpSecondsRemaining = 5;
    });

    final success = await _btService.sendCommand('1', actionDescription: 'Diagnostic 5s Pump Test');
    if (!success) {
      setState(() {
        _isTestingPump = false;
        _testPumpSecondsRemaining = 0;
      });
      return;
    }

    _testPumpTimer?.cancel();
    _testPumpTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_testPumpSecondsRemaining > 1) {
        setState(() {
          _testPumpSecondsRemaining--;
        });
      } else {
        timer.cancel();
        _testPumpTimer = null;
        await _btService.sendCommand('0', actionDescription: 'Diagnostic 5s Pump Test Complete');
        if (mounted) {
          setState(() {
            _isTestingPump = false;
            _testPumpSecondsRemaining = 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n?.pumpTestCompleted ?? '5-Second Pump Test Completed Successfully.'),
              backgroundColor: const Color(0xFF2E7D32),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        title: Text(
          l10n?.watchdogDiagnosticsTitle ?? 'WATCHDOG & DIAGNOSTICS',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white, letterSpacing: 1.1),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 2,
      ),
      body: ListenableBuilder(
        listenable: _btService,
        builder: (context, _) {
          final isConnected = _btService.connectionState == BtcConnectionState.connected;
          final isGattReady = _btService.isGattReady;
          final isWatchdogActive = _btService.isWatchdogActive;
          final lastHbSec = _btService.secondsSinceLastHeartbeat;
          final lastCmd = _btService.lastSentCommand ?? l10n?.na ?? 'None';

          final connText = isConnected ? (l10n?.connected ?? 'CONNECTED') : (l10n?.disconnected ?? 'DISCONNECTED');
          final gattText = isGattReady ? (l10n?.ready ?? 'READY') : (l10n?.notReady ?? 'NOT READY');
          final availText = isGattReady ? (l10n?.available ?? 'FOUND') : (l10n?.unavailable ?? 'NOT FOUND');
          final pumpStateText = _btService.isPumpOn ? (l10n?.onCommanded ?? 'ON') : (l10n?.off ?? 'OFF');
          final wdText = isWatchdogActive ? (l10n?.activePulse ?? 'ACTIVE') : (l10n?.inactive ?? 'INACTIVE');
          final hbText = lastHbSec != null ? (l10n?.secAgo(lastHbSec) ?? '$lastHbSec sec ago') : (l10n?.na ?? 'N/A');

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Hardware Parameters Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.developer_board, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 8),
                          Text(
                            l10n?.hardwareBleMetrics ?? 'HARDWARE & BLE METRICS',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.0),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildDiagRow('Controller MAC', '4D:50:04:EE:89:AA'),
                      _buildDiagRow(l10n?.bluetoothConnection ?? 'BLE Connection', connText, isOk: isConnected),
                      _buildDiagRow(l10n?.gattProtocol ?? 'GATT Readiness', gattText, isOk: isGattReady),
                      _buildDiagRow('Service FFE0', availText, isOk: isGattReady),
                      _buildDiagRow('Characteristic FFE1', availText, isOk: isGattReady),
                      _buildDiagRow(l10n?.pumpCommandState ?? 'Pump Command State', pumpStateText, isOk: _btService.isPumpOn),
                      _buildDiagRow(l10n?.watchdogSafety ?? 'Watchdog Status', wdText, isOk: isWatchdogActive),
                      _buildDiagRow('Last Sent Command', lastCmd),
                      _buildDiagRow(l10n?.lastHeartbeat ?? 'Last Heartbeat ("H")', hbText),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Diagnostic Actions Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.diagnosticTestSuite ?? 'DIAGNOSTIC TEST SUITE',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.sync, color: Color(0xFF2E7D32)),
                          label: Text(l10n?.testConnection ?? 'TEST CONNECTION'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2E7D32)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _runConnectionTest,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          icon: _isTestingPump
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.timer, color: Colors.white),
                          label: Text(_isTestingPump
                              ? (l10n?.testingPump(_testPumpSecondsRemaining) ?? 'TESTING PUMP ($_testPumpSecondsRemaining s)')
                              : (l10n?.testPump5s ?? 'TEST PUMP FOR 5 SECONDS')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: isConnected && !_isTestingPump ? _run5SecondPumpTest : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_testLog.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  color: Colors.grey.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SelectableText(
                      _testLog,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.lightGreenAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildDiagRow(String label, String value, {bool? isOk}) {
    Color? valColor;
    if (isOk != null) {
      valColor = isOk ? const Color(0xFF2E7D32) : Colors.orange.shade800;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
