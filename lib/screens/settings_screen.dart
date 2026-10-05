import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_translations.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';
import 'diagnostics_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settings = SettingsService();
  final NotificationService _notifService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n?.settings ?? 'Settings',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF2E7D32),
            elevation: 2,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Farmer Mode Toggle Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SwitchListTile(
                    activeThumbColor: const Color(0xFF2E7D32),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.agriculture, color: Color(0xFF2E7D32), size: 24),
                    ),
                    title: Text(
                      l10n?.farmerMode ?? 'Farmer Mode (Simple UI)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      l10n?.farmerModeSubtitle ?? 'Large buttons, big text, easy for daily farm use.',
                      style: const TextStyle(fontSize: 12),
                    ),
                    value: _settings.isFarmerMode,
                    onChanged: (val) {
                      _settings.setFarmerMode(val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Language Selector Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.language, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 8),
                          Text(
                            l10n?.language ?? 'Language',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...AppLanguage.values.map((lang) {
                        final isSelected = _settings.language == lang;
                        return ListTile(
                          title: Text(
                            lang.displayName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? const Color(0xFF2E7D32) : null,
                            ),
                          ),
                          leading: Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                          ),
                          onTap: () => _settings.setLanguage(lang),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notification Settings & Permission Card
              ListenableBuilder(
                listenable: _notifService,
                builder: (context, _) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.notifications_active_outlined, color: Color(0xFF2E7D32)),
                              const SizedBox(width: 8),
                              Text(
                                l10n?.notifications ?? _settings.tr('notifications'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Android Permission Status Row
                          FutureBuilder<bool>(
                            future: _notifService.checkPermission(),
                            builder: (context, snapshot) {
                              final isGranted = snapshot.data ?? false;
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isGranted ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isGranted ? const Color(0xFFA5D6A7) : const Color(0xFFFFCC80),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          isGranted ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                                          color: isGranted ? const Color(0xFF2E7D32) : Colors.orange.shade800,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '${_settings.tr('notificationPermission')}: ${isGranted ? _settings.tr('enabled') : _settings.tr('disabled')}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: isGranted ? const Color(0xFF1B5E20) : Colors.orange.shade900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: isGranted ? const Color(0xFF2E7D32) : Colors.orange.shade900,
                                          side: BorderSide(
                                            color: isGranted ? const Color(0xFF2E7D32) : Colors.orange.shade800,
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                        ),
                                        icon: const Icon(Icons.settings, size: 16),
                                        label: Text(
                                          _settings.tr('openNotificationSettings'),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                        onPressed: () async {
                                          if (!isGranted) {
                                            await _notifService.requestPermission();
                                          }
                                          await _notifService.openNotificationSettings();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Master Switch
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              _settings.tr('masterNotifications'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            value: _notifService.masterEnabled,
                            activeThumbColor: const Color(0xFF2E7D32),
                            onChanged: (val) {
                              _notifService.savePreferences(
                                master: val,
                                safety: _notifService.enableSafetyEvents,
                                irrigation: _notifService.enableIrrigationEvents,
                                missed: _notifService.enableMissedEvents,
                                reminders: _notifService.enableReminderEvents,
                                connection: _notifService.enableConnectionEvents,
                                dailySummary: _notifService.enableDailySummary,
                              );
                            },
                          ),
                          const Divider(height: 16),

                          // Category Switches
                          Opacity(
                            opacity: _notifService.masterEnabled ? 1.0 : 0.5,
                            child: AbsorbPointer(
                              absorbing: !_notifService.masterEnabled,
                              child: Column(
                                children: [
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_settings.tr('safetyAlerts'), style: const TextStyle(fontSize: 13)),
                                    subtitle: const Text('BLE drop while pump ON', style: TextStyle(fontSize: 11)),
                                    value: _notifService.enableSafetyEvents,
                                    activeThumbColor: const Color(0xFF2E7D32),
                                    onChanged: (val) {
                                      _notifService.savePreferences(
                                        master: _notifService.masterEnabled,
                                        safety: val,
                                        irrigation: _notifService.enableIrrigationEvents,
                                        missed: _notifService.enableMissedEvents,
                                        reminders: _notifService.enableReminderEvents,
                                        connection: _notifService.enableConnectionEvents,
                                        dailySummary: _notifService.enableDailySummary,
                                      );
                                    },
                                  ),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_settings.tr('irrigationCompletedNotif'), style: const TextStyle(fontSize: 13)),
                                    value: _notifService.enableIrrigationEvents,
                                    activeThumbColor: const Color(0xFF2E7D32),
                                    onChanged: (val) {
                                      _notifService.savePreferences(
                                        master: _notifService.masterEnabled,
                                        safety: _notifService.enableSafetyEvents,
                                        irrigation: val,
                                        missed: _notifService.enableMissedEvents,
                                        reminders: _notifService.enableReminderEvents,
                                        connection: _notifService.enableConnectionEvents,
                                        dailySummary: _notifService.enableDailySummary,
                                      );
                                    },
                                  ),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_settings.tr('missedIrrigationNotif'), style: const TextStyle(fontSize: 13)),
                                    value: _notifService.enableMissedEvents,
                                    activeThumbColor: const Color(0xFF2E7D32),
                                    onChanged: (val) {
                                      _notifService.savePreferences(
                                        master: _notifService.masterEnabled,
                                        safety: _notifService.enableSafetyEvents,
                                        irrigation: _notifService.enableIrrigationEvents,
                                        missed: val,
                                        reminders: _notifService.enableReminderEvents,
                                        connection: _notifService.enableConnectionEvents,
                                        dailySummary: _notifService.enableDailySummary,
                                      );
                                    },
                                  ),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_settings.tr('upcomingReminders'), style: const TextStyle(fontSize: 13)),
                                    subtitle: const Text('15 min before schedule', style: TextStyle(fontSize: 11)),
                                    value: _notifService.enableReminderEvents,
                                    activeThumbColor: const Color(0xFF2E7D32),
                                    onChanged: (val) {
                                      _notifService.savePreferences(
                                        master: _notifService.masterEnabled,
                                        safety: _notifService.enableSafetyEvents,
                                        irrigation: _notifService.enableIrrigationEvents,
                                        missed: _notifService.enableMissedEvents,
                                        reminders: val,
                                        connection: _notifService.enableConnectionEvents,
                                        dailySummary: _notifService.enableDailySummary,
                                      );
                                    },
                                  ),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_settings.tr('dailySummaryNotif'), style: const TextStyle(fontSize: 13)),
                                    value: _notifService.enableDailySummary,
                                    activeThumbColor: const Color(0xFF2E7D32),
                                    onChanged: (val) {
                                      _notifService.savePreferences(
                                        master: _notifService.masterEnabled,
                                        safety: _notifService.enableSafetyEvents,
                                        irrigation: _notifService.enableIrrigationEvents,
                                        missed: _notifService.enableMissedEvents,
                                        reminders: _notifService.enableReminderEvents,
                                        connection: _notifService.enableConnectionEvents,
                                        dailySummary: val,
                                      );
                                    },
                                  ),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_settings.tr('connectionEvents'), style: const TextStyle(fontSize: 13)),
                                    value: _notifService.enableConnectionEvents,
                                    activeThumbColor: const Color(0xFF2E7D32),
                                    onChanged: (val) {
                                      _notifService.savePreferences(
                                        master: _notifService.masterEnabled,
                                        safety: _notifService.enableSafetyEvents,
                                        irrigation: _notifService.enableIrrigationEvents,
                                        missed: _notifService.enableMissedEvents,
                                        reminders: _notifService.enableReminderEvents,
                                        connection: val,
                                        dailySummary: _notifService.enableDailySummary,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Diagnostics & System Info Tile
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.build_circle_outlined, color: Color(0xFF2E7D32)),
                  ),
                  title: Text(
                    l10n?.diagnostics ?? _settings.tr('diagnostics'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(l10n?.diagnosticsSubtitle ?? 'BLE GATT status, heartbeat & 5s pump test'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DiagnosticsScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // About Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'Smart Farm v1.0.0+1',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n?.aboutSubtitle ?? 'Bluetooth-Based Wireless Irrigation Controller',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
