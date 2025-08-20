import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'overview.dart';
import 'services/bluetooth_service.dart';
import 'screens/settings_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flavorly',
      theme: AppTheme.lightTheme,
      home: const StartScreen(),
    );
  }
}

// Startbildschirm mit Logo und Buttons
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final BluetoothService _bluetooth = BluetoothService();
  fbp.BluetoothDevice? _connectedDevice;
  bool _isScanning = false;
  bool _isConnecting = false;

  // Stream-Subscriptions für ordnungsgemäße Entsorgung
  StreamSubscription<fbp.BluetoothDevice?>? _connectionSubscription;
  StreamSubscription<List<fbp.ScanResult>>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    // Bluetooth-State überprüfen
    bool isSupported = await _bluetooth.checkBluetoothState();
    if (!isSupported) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bluetooth wird auf diesem Gerät nicht unterstützt'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Bluetooth-Adapter-State überprüfen
    var adapterState = await fbp.FlutterBluePlus.adapterState.first;
    if (adapterState != fbp.BluetoothAdapterState.on) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bitte aktivieren Sie Bluetooth'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      // Trotzdem versuchen, nach einer kurzen Verzögerung
      await Future.delayed(const Duration(seconds: 2));
    }

    // Bluetooth-Listener einrichten
    _connectionSubscription = _bluetooth.connectionState.listen((device) {
      if (mounted) {
        setState(() {
          _connectedDevice = device;
          _isConnecting = false;
        });

        // Erfolgsmeldung bei Verbindung
        if (device != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verbunden mit ${device.platformName}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });

    _scanSubscription = _bluetooth.scanResultsStream.listen((results) {
      if (mounted) {
        setState(() {
          _isScanning = _bluetooth.isScanning;
        });
      }
    });

    // Scan starten
    _startBluetoothScan();
  }

  void _startBluetoothScan() {
    if (mounted) {
      setState(() {
        _isScanning = true;
      });
    }

    _bluetooth.startScan();

    // Scan nach 10 Sekunden stoppen
    Future.delayed(const Duration(seconds: 10), () {
      if (_isScanning && mounted) {
        _bluetooth.stopScan();
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Stream-Subscriptions ordnungsgemäß beenden
    _connectionSubscription?.cancel();
    _scanSubscription?.cancel();
    _bluetooth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset('assets/flavorly.png', height: 120, width: 120),
                    const SizedBox(height: 24),
                    Text(
                      'flavorly',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Bluetooth Status
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        _connectedDevice != null ? Colors.green : Colors.orange,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _connectedDevice != null
                          ? Icons.bluetooth_connected
                          : _isScanning
                          ? Icons.bluetooth_searching
                          : Icons.bluetooth_disabled,
                      color:
                          _connectedDevice != null
                              ? Colors.green
                              : Colors.orange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _connectedDevice != null
                            ? 'Verbunden mit Arduino'
                            : _isConnecting
                            ? 'Verbinde...'
                            : _isScanning
                            ? 'Suche Arduino...'
                            : 'Bluetooth nicht verbunden',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              _connectedDevice != null
                                  ? Colors.green
                                  : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (_isScanning || _isConnecting)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Start Button
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed:
                      _connectedDevice != null
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OverviewScreen(),
                              ),
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _connectedDevice != null
                            ? AppColors.primary
                            : Colors.grey,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: _connectedDevice != null ? 6 : 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Start',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Settings Button
              SizedBox(
                width: 300,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                SettingsScreen(bluetoothService: _bluetooth),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.settings, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Einstellungen',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Debug Button - erlaubt Start ohne Bluetooth
              SizedBox(
                width: 300,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OverviewScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bug_report, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Debug',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Retry Button (nur wenn nicht verbunden)
              if (_connectedDevice == null && !_isScanning && !_isConnecting)
                TextButton(
                  onPressed: _startBluetoothScan,
                  child: Text(
                    'Erneut suchen',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
