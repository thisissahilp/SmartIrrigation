import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bluetooth/bluetooth_service.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/settings_service.dart';
import 'services/weather_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Settings, Notifications & Weather
  final settingsService = SettingsService();
  await settingsService.init();

  final notificationService = NotificationService();
  await notificationService.init();

  final weatherService = WeatherService();
  await weatherService.init();

  // Initialize the Bluetooth Service singleton
  final bluetoothService = BluetoothService();
  await bluetoothService.init();
  final hasPerm = await bluetoothService.requestPermissions();
  if (hasPerm) {
    await bluetoothService.loadPairedDevices();
  }

  runApp(const SmartFarmApp());
}

class SmartFarmApp extends StatelessWidget {
  const SmartFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsService();

    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        return MaterialApp(
          title: 'Smart Farm',
          debugShowCheckedModeBanner: false,
          locale: settings.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2E7D32),
              primary: const Color(0xFF2E7D32),
              secondary: const Color(0xFF0288D1),
              error: const Color(0xFFC62828),
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFFF4F6F4),
            cardTheme: CardThemeData(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
