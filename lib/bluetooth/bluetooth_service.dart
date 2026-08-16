import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothService extends ChangeNotifier {
  // Singleton instance
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  final FlutterClassicBluetooth _bt = FlutterClassicBluetooth();

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
  BtcConnectionState _connectionState = BtcConnectionState.disconnected;
  BtcConnectionState get connectionState => _connectionState;

  String? _connectedDeviceName;
  String? get connectedDeviceName => _connectedDeviceName;

  bool _isPumpOn = false;
  bool get isPumpOn => _isPumpOn;

  String? _lastError;
  String? get lastError => _lastError;

  String? _lastCommandStatus;
  String? get lastCommandStatus => _lastCommandStatus;

  StreamSubscription<BtcAdapterState>? _adapterStateSubscription;
  StreamSubscription<BtcDevice>? _discoverySubscription;
  StreamSubscription<BtcConnectionState>? _connectionStateSubscription;
  StreamSubscription<String>? _dataSubscription;

  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  void clearCommandStatus() {
    _lastCommandStatus = null;
    notifyListeners();
  }

  /// Initialize permissions and listen to adapter state changes
  Future<void> init() async {
    if (_initialized) return;

    // Listen to Bluetooth adapter state changes
    _adapterStateSubscription = _bt.adapterState.listen((state) {
      _isBluetoothOn = state == BtcAdapterState.on;
      notifyListeners();
    });

    // Check current adapter state
    _isBluetoothOn = await _bt.isEnabled();

    _initialized = true;
    notifyListeners();
  }

  /// Requests permissions for Bluetooth Classic operations on Android.
  Future<bool> requestPermissions() async {
    try {
      // Permission request logic
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      _hasPermission =
          statuses[Permission.bluetoothScan]?.isGranted == true &&
          statuses[Permission.bluetoothConnect]?.isGranted == true;

      notifyListeners();
      return _hasPermission;
    } catch (e) {
      _lastError = 'Failed to request permissions: $e';
      notifyListeners();
      return false;
    }
  }

  /// Refresh the list of paired devices
  Future<void> loadPairedDevices() async {
    try {
      final devices = await _bt.getPairedDevices();
      _pairedDevices = devices;
      notifyListeners();
    } catch (e) {
      _lastError = 'Failed to load paired devices: $e';
      notifyListeners();
    }
  }

  /// Start discovery scan for new devices
  Future<void> startDiscovery() async {
    if (_isScanning) return;
    _discoveredDevices.clear();
    _isScanning = true;
    notifyListeners();

    try {
      _discoverySubscription = _bt.discoveryResults.listen(
        (device) {
          if (!_discoveredDevices.any((d) => d.address == device.address)) {
            _discoveredDevices.add(device);
            notifyListeners();
          }
        },
        onError: (e) {
          _lastError = 'Discovery error: $e';
          _isScanning = false;
          notifyListeners();
        },
        onDone: () {
          _isScanning = false;
          notifyListeners();
        },
      );

      await _bt.startDiscovery();
    } catch (e) {
      _lastError = 'Failed to start discovery: $e';
      _isScanning = false;
      notifyListeners();
    }
  }

  /// Stop discovery scan
  Future<void> stopDiscovery() async {
    if (!_isScanning) return;
    try {
      await _discoverySubscription?.cancel();
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _lastError = 'Failed to stop discovery: $e';
      notifyListeners();
    }
  }

  /// Connect to a Bluetooth device
  Future<void> connect(BtcDevice device) async {
    // If already connected, disconnect first
    if (_connection != null) {
      await disconnect();
    }

    _connectionState = BtcConnectionState.connecting;
    _connectedDeviceName = device.displayName;
    notifyListeners();

    try {
      // Connect using SPP UUID (standard Serial Port Profile UUID)
      final conn = await _bt.connect(
        address: device.address,
        uuid: '00001101-0000-1000-8000-00805F9B34FB',
        timeout: const Duration(seconds: 15),
      );

      _connection = conn;
      _connectionState = BtcConnectionState.connected;
      notifyListeners();

      // Listen to connection state stream
      _connectionStateSubscription = conn.stateStream.listen((state) {
        _connectionState = state;
        if (state == BtcConnectionState.disconnected) {
          _handleDisconnect();
        }
        notifyListeners();
      });

      // Listen to data input stream
      _dataSubscription = conn.input.lines().listen(
        (line) {
          _handleIncomingData(line);
        },
        onError: (e) {
          _lastError = 'Data stream error: $e';
          notifyListeners();
        },
        onDone: () {
          _handleDisconnect();
        },
      );
    } catch (e) {
      _connectionState = BtcConnectionState.disconnected;
      _connectedDeviceName = null;
      _connection = null;
      _lastError =
          'Connection failed: $e. Make sure the HC-05 module is powered on and paired.';
      notifyListeners();
    }
  }

  /// Send command to Arduino
  Future<void> sendCommand(String command) async {
    if (_connection == null ||
        _connectionState != BtcConnectionState.connected) {
      _lastError = 'Bluetooth not connected. Please connect to HC-05 first.';
      notifyListeners();
      return;
    }

    try {
      // Append newline as standard serial communication protocol
      final payload = '$command\n';
      final bytes = Uint8List.fromList(utf8.encode(payload));
      await _connection!.output.writeBytes(bytes);
      _lastCommandStatus = "Sent: '$command'";
      notifyListeners();
    } catch (e) {
      _lastError = 'Failed to send command: $e';
      notifyListeners();
    }
  }

  /// Disconnect connection
  Future<void> disconnect() async {
    if (_connection == null) return;
    try {
      await _dataSubscription?.cancel();
      await _connectionStateSubscription?.cancel();
      await _connection!.close();
    } catch (e) {
      // Ignore errors on closing
    } finally {
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    _connection = null;
    _connectionState = BtcConnectionState.disconnected;
    _connectedDeviceName = null;
    _dataSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    notifyListeners();
  }

  void _handleIncomingData(String line) {
    // Trim to ignore whitespaces/newlines
    final trimmed = line.trim();
    if (trimmed.contains('PUMP ON')) {
      _isPumpOn = true;
      _lastCommandStatus = 'Confirmed: Pump ON';
    } else if (trimmed.contains('PUMP OFF')) {
      _isPumpOn = false;
      _lastCommandStatus = 'Confirmed: Pump OFF';
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _discoverySubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _dataSubscription?.cancel();
    _connection?.close();
    super.dispose();
  }
}
