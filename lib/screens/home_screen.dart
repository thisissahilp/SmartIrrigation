import 'dart:async';
import 'package:flutter/material.dart';
import '../bluetooth/bluetooth_service.dart';
import '../l10n/app_localizations.dart';
import '../services/irrigation_service.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';
import '../widgets/activity_log_card.dart';
import '../widgets/bluetooth_status_card.dart';
import '../widgets/emergency_stop_button.dart';
import '../widgets/in_app_alert_banner.dart';
import '../widgets/interruption_alert_dialog.dart';
import '../widgets/irrigation_summary_card.dart';
import '../widgets/irrigation_timer_card.dart';
import '../widgets/pump_control_buttons.dart';
import '../widgets/pump_status_card.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/scheduled_irrigation_card.dart';
import '../widgets/system_status_card.dart';
import '../widgets/weather_card.dart';
import 'analytics_screen.dart';
import 'diagnostics_screen.dart';
import 'history_screen.dart';
import 'schedules_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final BluetoothService _bluetoothService = BluetoothService();
  final IrrigationService _irrigationService = IrrigationService();
  final SettingsService _settingsService = SettingsService();

  StreamSubscription<String>? _navSub;

  @override
  void initState() {
    super.initState();
    _irrigationService.init();
    _irrigationService.addListener(_checkInterruptionAlert);

    _navSub = NotificationService().navigationStream.listen((routePayload) {
      if (mounted) {
        _handleDeepLink(routePayload);
      }
    });
  }

  void _handleDeepLink(String route) {
    setState(() {
      if (route == 'schedules') {
        _currentIndex = 1;
      } else if (route == 'history') {
        _currentIndex = 2;
      } else if (route == 'analytics') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
        );
      } else {
        _currentIndex = 0;
      }
    });
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _irrigationService.removeListener(_checkInterruptionAlert);
    super.dispose();
  }

  void _checkInterruptionAlert() {
    final interruptedSession = _irrigationService.lastInterruptedSession;
    if (interruptedSession != null && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => InterruptionAlertDialog(
          session: interruptedSession,
          onDismiss: () {
            _irrigationService.clearLastInterruptedSession();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _settingsService,
      builder: (context, _) {
        final currentTitle = l10n?.appTitle ?? 'SMART FARM';
        final currentSub = _currentIndex == 0
            ? (l10n?.appSubtitle ?? 'Wireless Irrigation Controller')
            : (_currentIndex == 1 ? (l10n?.schedules ?? 'Schedules') : (l10n?.history ?? 'History'));

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
                Text(
                  currentSub,
                  style: const TextStyle(
                    fontSize: 11,
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
                icon: const Icon(Icons.analytics_outlined, color: Colors.white),
                tooltip: _settingsService.tr('farmAnalytics'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {
                  _showAboutDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.build_circle_outlined, color: Colors.white),
                tooltip: l10n?.diagnostics ?? 'Watchdog & Diagnostics',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DiagnosticsScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                tooltip: l10n?.settings ?? 'Settings',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _settingsService.isFarmerMode ? _buildFarmerModeTab(context) : _buildDashboardTab(context),
              const SchedulesScreen(),
              const HistoryScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: const Color(0xFF2E7D32),
            unselectedItemColor: Colors.grey.shade600,
            elevation: 8,
            selectedFontSize: _settingsService.isFarmerMode ? 14 : 12,
            unselectedFontSize: _settingsService.isFarmerMode ? 14 : 12,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard_outlined),
                activeIcon: const Icon(Icons.dashboard),
                label: l10n?.dashboard ?? 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.schedule_outlined),
                activeIcon: const Icon(Icons.schedule),
                label: l10n?.schedules ?? 'Schedules',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.history_outlined),
                activeIcon: const Icon(Icons.history),
                label: l10n?.history ?? 'History',
              ),
            ],
          ),
        );
      },
    );
  }

  /// Farmer Mode (Simple UI Dashboard)
  Widget _buildFarmerModeTab(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: Listenable.merge([_bluetoothService, _irrigationService]),
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Dismissible In-App Alert Banner
              InAppAlertBanner(onNavigate: _handleDeepLink),

              const SizedBox(height: 12),
              const BluetoothStatusCard(),
              const SizedBox(height: 16),
              const PumpStatusCard(),
              const SizedBox(height: 16),
              const PumpControlButtons(),
              const SizedBox(height: 16),
              const EmergencyStopButton(),
              const SizedBox(height: 16),
              const IrrigationSummaryCard(),
              const SizedBox(height: 16),
              RecommendationCard(onNavigate: _handleDeepLink),
              const SizedBox(height: 16),
              WeatherCard(onNavigateToSchedules: () => _handleDeepLink('schedules')),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  /// Standard Dashboard Tab
  Widget _buildDashboardTab(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: Listenable.merge([_bluetoothService, _irrigationService]),
        builder: (context, _) {
          return Column(
            children: [
              // Dismissible In-App Alert Banner
              InAppAlertBanner(onNavigate: _handleDeepLink),

              if (_bluetoothService.lastError != null)
                Container(
                  width: double.infinity,
                  color: Colors.orange[900],
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _bluetoothService.lastError!,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _bluetoothService.clearError(),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const BluetoothStatusCard(),
                    const SizedBox(height: 16),
                    const SystemStatusCard(),
                    const SizedBox(height: 16),
                    const PumpStatusCard(),
                    const SizedBox(height: 16),
                    const PumpControlButtons(),
                    const SizedBox(height: 16),
                    const EmergencyStopButton(),
                    const SizedBox(height: 16),
                    const IrrigationSummaryCard(),
                    const SizedBox(height: 16),
                    RecommendationCard(onNavigate: _handleDeepLink),
                    const SizedBox(height: 16),
                    WeatherCard(onNavigateToSchedules: () => _handleDeepLink('schedules')),
                    const SizedBox(height: 16),
                    const ScheduledIrrigationCard(),
                    const SizedBox(height: 16),
                    const IrrigationTimerCard(),
                    const SizedBox(height: 16),
                    const ActivityLogCard(),
                    const SizedBox(height: 16),

                    if (_bluetoothService.lastCommandStatus != null)
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
                              Expanded(
                                child: Text(
                                  'Status: ${_bluetoothService.lastCommandStatus}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _bluetoothService.clearCommandStatus(),
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n?.appTitle ?? 'Smart Farm System'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.appSubtitle ?? 'Wireless Irrigation Controller',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Architecture:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Flutter App → HC-05 (BLE GATT FFE0/FFE1) → Arduino UNO → Relay → 5V Water Pump'),
            const SizedBox(height: 12),
            const Text('Protocol & Safety:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('• "1" (0x31) -> Pump ON'),
            const Text('• "0" (0x30) -> Pump OFF'),
            const Text('• "H" (0x48) -> Heartbeat (500ms)'),
            const Text('• Arduino 2s Hardware Watchdog'),
            const SizedBox(height: 8),
            const Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• ${l10n?.farmerMode ?? "Farmer Mode & Multilingual UI"}'),
            Text('• ${l10n?.emergencyStop ?? "Quick Emergency Stop"}'),
            Text('• ${l10n?.systemAndConnectionStatus ?? "System & Range Status"}'),
            Text('• ${l10n?.diagnostics ?? "Watchdog Diagnostics"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.close ?? 'OK'),
          ),
        ],
      ),
    );
  }
}
