// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/activity_log_entry.dart';

/// Helper to safely resolve a human-readable title for a Bluetooth device.
String getDeviceTitle(BtcDevice device) {
  if (device.name != null && device.name!.trim().isNotEmpty) {
    return device.name!.trim();
  }
  if (device.alias != null && device.alias!.trim().isNotEmpty) {
    return device.alias!.trim();
  }
  if (device.displayName.trim().isNotEmpty && device.displayName.trim() != device.address) {
    return device.displayName.trim();
  }
  return device.address;
}

class BluetoothService extends ChangeNotifier {
  // Singleton instance
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  final FlutterClassicBluetooth _bt = FlutterClassicBluetooth();
  static const MethodChannel _nativeBtChannel = MethodChannel('com.smartfarm.smart_farm/native_bluetooth');

  bool _initialized = false;
  bool get initialized => _initialized;

  bool _hasPermission = false;
  bool get hasPermission => _hasPermission;

  bool _isBluetoothOn = false;
  bool get isBluetoothOn => _isBluetoothOn;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  List<BtcDevice> _pairedDevices = [];
  List<BtcDevice> get pairedDevices => _pairedDevices;

  final List<BtcDevice> _discoveredDevices = [];
  List<BtcDevice> get discoveredDevices => _discoveredDevices;

  BtcConnection? _connection;
  bool _isNativeConnected = false;
  bool get isNativeConnected => _isNativeConnected;

  BtcConnectionState _connectionState = BtcConnectionState.disconnected;
  BtcConnectionState get connectionState => _connectionState;

  String? _connectedDeviceName;
  String? get connectedDeviceName => _connectedDeviceName;

  bool _isPumpOn = false;
  bool get isPumpOn => _isPumpOn;

  bool _isWriteInProgress = false;
  bool get isWriteInProgress => _isWriteInProgress;

  String? _lastError;
  String? get lastError => _lastError;

  String? _lastCommandStatus;
  String? get lastCommandStatus => _lastCommandStatus;

  DateTime? _lastHeartbeatTime;
  DateTime? get lastHeartbeatTime => _lastHeartbeatTime;

  String? _lastSentCommand;
  String? get lastSentCommand => _lastSentCommand;

  bool get isGattReady => _isNativeConnected && _connectionState == BtcConnectionState.connected;
  bool get isWatchdogActive => _isPumpOn && _heartbeatTimer != null;

  int? get secondsSinceLastHeartbeat =>
      _lastHeartbeatTime != null ? DateTime.now().difference(_lastHeartbeatTime!).inSeconds : null;

  final List<ActivityLogEntry> _activityLogs = [];
  List<ActivityLogEntry> get activityLogs => List.unmodifiable(_activityLogs);

  StreamSubscription<BtcAdapterState>? _adapterStateSubscription;
  StreamSubscription<BtcDevice>? _discoverySubscription;
  StreamSubscription<BtcConnectionState>? _connectionStateSubscription;
  StreamSubscription<dynamic>? _dataSubscription;

  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  void clearCommandStatus() {
    _lastCommandStatus = null;
    notifyListeners();
  }

  void addActivityLog(String title, String details) {
    _activityLogs.insert(
      0,
      ActivityLogEntry(
        timestamp: DateTime.now(),
        title: title,
        details: details,
      ),
    );
    if (_activityLogs.length > 30) {
      _activityLogs.removeLast();
    }
    notifyListeners();
  }

  Future<List<BtcDevice>> _fetchNativeBondedDevices() async {
    try {
      final List<dynamic>? list = await _nativeBtChannel.invokeMethod('getNativeBondedDevices');
      if (list == null) return [];
      return list.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return BtcDevice.fromMap(map);
      }).toList();
    } catch (e) {
      print('Native MethodChannel error: $e');
      return [];
    }
  }

  /// Initialize listeners and check initial adapter state
  Future<void> init() async {
    if (_initialized) return;

    _nativeBtChannel.setMethodCallHandler((call) async {
      if (call.method == 'onNativeDisconnected') {
        print('[BLE CONNECT] Native GATT disconnection callback received');
        _handleDisconnect(reason: 'Bluetooth/Device connection lost while pump was ON.');
      }
    });

    _adapterStateSubscription = _bt.adapterState.listen((state) {
      _isBluetoothOn = state == BtcAdapterState.on;
      if (!_isBluetoothOn && _connectionState == BtcConnectionState.connected) {
        _handleDisconnect(reason: 'Bluetooth turned off on device');
      }
      notifyListeners();
    });

    try {
      _isBluetoothOn = await _bt.isEnabled();
    } catch (_) {
      _isBluetoothOn = false;
    }

    _initialized = true;
    notifyListeners();
  }

  /// Requests permissions for Bluetooth Classic operations on Android.
  Future<bool> requestPermissions() async {
    try {
      final statuses = await [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.location,
      ].request();

      final connectStatus = statuses[Permission.bluetoothConnect];
      final scanStatus = statuses[Permission.bluetoothScan];

      bool granted = true;
      if (connectStatus != null && connectStatus.isDenied) granted = false;
      if (scanStatus != null && scanStatus.isDenied) granted = false;

      _hasPermission = granted;

      if (!_hasPermission) {
        _lastError = 'Bluetooth permission is required.';
      } else {
        _lastError = null;
      }

      notifyListeners();
      return _hasPermission;
    } catch (e) {
      print('Permission error: $e');
      _lastError = 'Bluetooth permission is required.';
      _hasPermission = false;
      notifyListeners();
      return false;
    }
  }

  /// Refresh the list of paired devices from Android system settings
  Future<void> loadPairedDevices() async {
    try {
      final connectGranted = await Permission.bluetoothConnect.isGranted;
      final scanGranted = await Permission.bluetoothScan.isGranted;

      print('BLUETOOTH_CONNECT = ${connectGranted ? "granted" : "denied"}');
      print('BLUETOOTH_SCAN = ${scanGranted ? "granted" : "denied"}');

      List<BtcDevice> pluginDevices = [];
      try {
        pluginDevices = await _bt.getPairedDevices();
      } catch (e) {
        print('Package getPairedDevices exception: $e');
      }

      print('=== FRESH PAIRED DEVICE QUERY ===');
      print('Count: ${pluginDevices.length}');
      for (final d in pluginDevices) {
        print('name: ${d.name}');
        print('displayName: ${d.displayName}');
        print('alias: ${d.alias}');
        print('address: ${d.address}');
        print('bondState: ${d.bondState.name}');
        print('uuids: ${d.uuids}');
      }

      final BtcDevice? hc05InPlugin = pluginDevices
          .where((d) => d.address.toUpperCase() == '4D:50:04:EE:89:AA')
          .firstOrNull;

      print('=== HC-05 FRESH CHECK ===');
      print('Found in getPairedDevices(): ${hc05InPlugin != null}');
      print('Name: ${hc05InPlugin?.name}');
      print('DisplayName: ${hc05InPlugin?.displayName}');
      print('Alias: ${hc05InPlugin?.alias}');
      print('Address: 4D:50:04:EE:89:AA');
      print('BondState: ${hc05InPlugin?.bondState.name}');
      print('UUIDs: ${hc05InPlugin?.uuids}');
      print('=============================');

      final nativeDevices = await _fetchNativeBondedDevices();
      print('=== NATIVE BONDED DEVICES FALLBACK ===');
      print('Count: ${nativeDevices.length}');
      for (final nd in nativeDevices) {
        print('Native -> Name: ${nd.name} | Address: ${nd.address} | BondState: ${nd.bondState.name} | UUIDs: ${nd.uuids}');
      }
      print('======================================');

      final Map<String, BtcDevice> combinedMap = {};
      for (final dev in pluginDevices) {
        combinedMap[dev.address.toUpperCase()] = dev;
      }
      for (final dev in nativeDevices) {
        final key = dev.address.toUpperCase();
        if (!combinedMap.containsKey(key)) {
          combinedMap[key] = dev;
        } else {
          combinedMap[key] = combinedMap[key]!.mergedWith(dev);
        }
      }

      _pairedDevices = combinedMap.values.toList();
      _lastError = null;
      notifyListeners();
    } catch (e) {
      print('Error fetching paired devices: $e');
      _lastError = 'Unable to fetch paired devices: $e';
      notifyListeners();
    }
  }

  /// Helper to find HC-05 / HC-06 module in paired devices
  BtcDevice? findPairedHC05() {
    for (final device in _pairedDevices) {
      final title = getDeviceTitle(device).toUpperCase();
      if (title.contains('HC-05') ||
          title.contains('HC-06') ||
          title.contains('HC05') ||
          title.contains('HC06') ||
          device.address.toUpperCase() == '4D:50:04:EE:89:AA') {
        return device;
      }
    }
    return null;
  }

  /// Connects directly to the paired HC-05 device if available
  Future<bool> connectToHC05() async {
    if (_connectionState == BtcConnectionState.connected) return true;
    if (!hasPermission) {
      final granted = await requestPermissions();
      if (!granted) return false;
    }
    if (_pairedDevices.isEmpty) {
      await loadPairedDevices();
    }
    final hc05 = findPairedHC05();
    if (hc05 != null) {
      return await connect(hc05);
    } else {
      return await connectToHC05Only();
    }
  }

  /// Single-shot BLE UART Communication Diagnostic test for HC-05
  Future<Map<String, dynamic>> runHc05BleUartTest() async {
    try {
      await stopDiscovery();
      await disconnect();
      await Future.delayed(const Duration(milliseconds: 500));

      final dynamic result = await _nativeBtChannel.invokeMethod('testHc05BleUart', {
        'address': '4D:50:04:EE:89:AA',
      });
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {'success': false, 'resultLog': 'Invalid test response from native channel'};
    } catch (e) {
      return {'success': false, 'resultLog': 'BLE UART Exception: $e'};
    }
  }

  /// Single-shot BLE GATT Structure Diagnostic test for HC-05
  Future<Map<String, dynamic>> runHc05BleGattTest() async {
    try {
      await stopDiscovery();
      await disconnect();
      await Future.delayed(const Duration(milliseconds: 500));

      final dynamic result = await _nativeBtChannel.invokeMethod('testHc05BleGatt', {
        'address': '4D:50:04:EE:89:AA',
      });
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {'success': false, 'resultLog': 'Invalid test response from native channel'};
    } catch (e) {
      return {'success': false, 'resultLog': 'BLE GATT Exception: $e'};
    }
  }

  /// Runs the exact serial terminal-style diagnostic test for HC-05
  Future<Map<String, dynamic>> runExactSppTest() async {
    try {
      await stopDiscovery();
      await disconnect();
      await Future.delayed(const Duration(milliseconds: 500));

      final dynamic result = await _nativeBtChannel.invokeMethod('testExactSppConnection', {
        'address': '4D:50:04:EE:89:AA',
      });
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {'success': false, 'resultLog': 'Invalid test response from native channel'};
    } catch (e) {
      return {'success': false, 'resultLog': 'Test exception: $e'};
    }
  }

  /// Single-shot diagnostic test for HC-05 connection
  Future<Map<String, dynamic>> runHC05DiagnosticTest() async {
    try {
      await stopDiscovery();
      await disconnect();
      await Future.delayed(const Duration(milliseconds: 500));

      final dynamic result = await _nativeBtChannel.invokeMethod('testHc05Connection', {
        'address': '4D:50:04:EE:89:AA',
      });
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {'success': false, 'resultLog': 'Invalid test response from native channel'};
    } catch (e) {
      return {'success': false, 'resultLog': 'Test exception: $e'};
    }
  }

  /// Diagnostic for comparing all bonded Bluetooth devices
  Future<Map<String, dynamic>> runAllBondedDiagnostics() async {
    try {
      final dynamic result = await _nativeBtChannel.invokeMethod('runAllBondedDiagnostics');
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {'success': false, 'log': 'Invalid response from native channel'};
    } catch (e) {
      return {'success': false, 'log': 'Diagnostics exception: $e'};
    }
  }

  /// Start optional discovery scan for new unpaired devices
  Future<void> startDiscovery() async {
    if (_isScanning) return;
    _discoveredDevices.clear();
    _isScanning = true;
    notifyListeners();

    print('=== STARTING CLASSIC DISCOVERY ===');

    try {
      _discoverySubscription = _bt.discoveryResults.listen(
        (device) {
          final isPaired = _pairedDevices.any((d) => d.address.toUpperCase() == device.address.toUpperCase());
          final isAlreadyDiscovered = _discoveredDevices.any((d) => d.address.toUpperCase() == device.address.toUpperCase());

          if (!isPaired && !isAlreadyDiscovered) {
            _discoveredDevices.add(device);
            notifyListeners();
          }
        },
        onError: (e) {
          print('Discovery error: $e');
          _lastError = 'Unable to scan for Bluetooth devices: $e';
          _isScanning = false;
          notifyListeners();
        },
        onDone: () {
          print('=== DISCOVERY FINISHED ===');
          _isScanning = false;
          notifyListeners();
        },
      );

      await _bt.startDiscovery();
    } catch (e) {
      print('Discovery start error: $e');
      _lastError = 'Unable to scan for Bluetooth devices: $e';
      _isScanning = false;
      notifyListeners();
    }
  }

  /// Stop discovery scan
  Future<void> stopDiscovery() async {
    if (!_isScanning) return;
    try {
      await _discoverySubscription?.cancel();
      await _bt.stopDiscovery();
    } catch (_) {
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  /// Single-shot connection specifically for HC-05
  Future<bool> connectToHC05Only() async {
    const address = '4D:50:04:EE:89:AA';
    return await _connectByAddress(address, 'HC-05');
  }

  /// Refresh paired devices without starting background discovery automatically
  Future<void> refreshDevices() async {
    await stopDiscovery();
    await loadPairedDevices();
  }

  /// Clean single SPP connection attempt to a Bluetooth device
  Future<bool> connect(BtcDevice device) async {
    final title = getDeviceTitle(device);
    return await _connectByAddress(device.address, title);
  }

  Future<bool> _connectByAddress(String address, String title) async {
    if (!isBluetoothOn) {
      _lastError = 'Bluetooth is turned off.';
      notifyListeners();
      return false;
    }

    await stopDiscovery();
    await disconnect();
    await Future.delayed(const Duration(milliseconds: 500));

    _connectionState = BtcConnectionState.connecting;
    _connectedDeviceName = title;
    _isPumpOn = false;
    _lastError = null;
    notifyListeners();

    print('=== BLE GATT PERSISTENT CONNECTION ATTEMPT ===');
    print('Device name: $title');
    print('Address: $address');
    print('Service UUID: 0000FFE0-0000-1000-8000-00805F9B34FB');
    print('Char UUID: 0000FFE1-0000-1000-8000-00805F9B34FB');
    print('===============================================');

    try {
      final dynamic rawRes = await _nativeBtChannel.invokeMethod('nativeConnect', {'address': address});
      final Map<dynamic, dynamic>? resMap = rawRes is Map ? rawRes : null;
      final bool isConnected = resMap?['isConnected'] == true;

      if (isConnected) {
        print('=== HC-05 BLE GATT CONNECTED SUCCESSFULLY ===');
        _isNativeConnected = true;
        _connectionState = BtcConnectionState.connected;
        _isPumpOn = false;
        _lastError = null;
        _lastCommandStatus = 'Connected to $title';
        addActivityLog('Connected', 'Connected to $title ($address) via BLE GATT');
        notifyListeners();
        return true;
      } else {
        final err = resMap?['error'] as String? ?? 'Connection failed';
        print('=== HC-05 BLE GATT CONNECTION FAILED ===');
        print('Error: $err');
        print('========================================');
        _connectionState = BtcConnectionState.disconnected;
        _connectedDeviceName = null;
        _connection = null;
        _isNativeConnected = false;
        _isPumpOn = false;
        _lastError = 'Connection failed: $err';
        addActivityLog('Connection Failed', 'Failed to connect to $title ($address): $err');
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Native connect MethodChannel exception: $e');
      _connectionState = BtcConnectionState.disconnected;
      _connectedDeviceName = null;
      _connection = null;
      _isNativeConnected = false;
      _isPumpOn = false;
      _lastError = 'MethodChannel exception: $e';
      addActivityLog('Connection Error', 'Exception connecting to $title ($address): $e');
      notifyListeners();
      return false;
    }
  }

  Timer? _heartbeatTimer;

  void startHeartbeat() {
    stopHeartbeat();
    print('[BLE HEARTBEAT] Starting periodic 500ms heartbeat ticker');
    _heartbeatTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _sendHeartbeatTick();
    });
  }

  void stopHeartbeat() {
    if (_heartbeatTimer != null) {
      print('[BLE HEARTBEAT] Stopping periodic heartbeat ticker');
      _heartbeatTimer?.cancel();
      _heartbeatTimer = null;
    }
  }

  Future<void> _sendHeartbeatTick() async {
    if (_connectionState != BtcConnectionState.connected || !_isPumpOn) {
      stopHeartbeat();
      return;
    }

    if (_isWriteInProgress) {
      print('[BLE HEARTBEAT] Skipping tick: write operation currently in progress');
      return;
    }

    _isWriteInProgress = true;
    try {
      final bool sent = await _nativeBtChannel.invokeMethod('nativeWrite', {'data': 'H'}) ?? false;
      if (sent) {
        _lastHeartbeatTime = DateTime.now();
        _lastSentCommand = 'H';
      } else {
        print('[BLE HEARTBEAT] "H" write returned false');
      }
    } catch (e) {
      print('[BLE HEARTBEAT] Heartbeat exception: $e');
    } finally {
      _isWriteInProgress = false;
    }
  }

  /// Send command ("1" for ON, "0" for OFF) via persistent BLE GATT characteristic FFE1
  Future<bool> sendCommand(String command, {String? actionDescription}) async {
    if (command == '0') {
      stopHeartbeat();
    }

    // If a heartbeat write is in progress, wait briefly for it to clear
    int waitCount = 0;
    while (_isWriteInProgress && waitCount < 6) {
      await Future.delayed(const Duration(milliseconds: 50));
      waitCount++;
    }

    // For OFF command, force clear the lock if still held by stale write
    if (command == '0' && _isWriteInProgress) {
      print('Forcing write lock release for PUMP OFF command');
      _isWriteInProgress = false;
    }

    if (_connectionState != BtcConnectionState.connected) {
      _lastError = 'Bluetooth disconnected — pump status unavailable.';
      notifyListeners();
      return false;
    }

    _isWriteInProgress = true;
    notifyListeners();

    try {
      print('=== SENDING BLE UART COMMAND ===');
      print('Command payload: ASCII "$command" (0x${command == '1' ? '31' : '30'})');
      print('================================');

      final bool sent = await _nativeBtChannel.invokeMethod('nativeWrite', {'data': command}) ?? false;
      if (!sent) {
        throw Exception('Native BLE GATT write failed');
      }

      _lastSentCommand = command;

      if (command == '1') {
        _isPumpOn = true;
        _lastCommandStatus = "Pump ON";
        addActivityLog('Pump ON', actionDescription ?? 'Pump turned ON via app');
        startHeartbeat();
      } else if (command == '0') {
        _isPumpOn = false;
        _lastCommandStatus = "Pump OFF";
        addActivityLog('Pump OFF', actionDescription ?? 'Pump turned OFF via app');
      }

      _lastError = null;
      return true;
    } catch (e) {
      print('sendCommand exception: $e');
      _lastError = 'Failed to send command: $e';
      return false;
    } finally {
      _isWriteInProgress = false;
      notifyListeners();
    }
  }

  /// Cleanup BLE GATT connection
  Future<void> disconnect() async {
    stopHeartbeat();
    try {
      await _dataSubscription?.cancel();
      await _connectionStateSubscription?.cancel();
      if (_connection != null) {
        await _connection!.close();
      }
      if (_isNativeConnected) {
        await _nativeBtChannel.invokeMethod('nativeDisconnect');
      }
    } catch (_) {
    } finally {
      _isNativeConnected = false;
      _handleDisconnect(reason: 'Disconnected by user');
    }
  }

  void _handleDisconnect({String? reason}) {
    stopHeartbeat();
    final wasConnected = _connectionState == BtcConnectionState.connected;
    _connection = null;
    _isNativeConnected = false;
    _connectionState = BtcConnectionState.disconnected;
    _connectedDeviceName = null;
    _isPumpOn = false;
    _isWriteInProgress = false;
    _dataSubscription?.cancel();
    _connectionStateSubscription?.cancel();

    if (wasConnected) {
      addActivityLog('Disconnected', reason ?? 'Bluetooth disconnected');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _discoverySubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _dataSubscription?.cancel();
    if (_connection != null) {
      _connection!.close();
    }
    if (_isNativeConnected) {
      _nativeBtChannel.invokeMethod('nativeDisconnect');
    }
    super.dispose();
  }
}
