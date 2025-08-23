import 'dart:async';
import 'bluetooth_service.dart';
import '../data/recipes.dart';

class RecipeExecutor {
  final BluetoothService _bluetooth;
  StreamSubscription<String>? _bluetoothDataSubscription;
  bool _debugMode = false; // Debug-Modus Flag
  bool useAlternativeMotorMode = false; // Alternativer Mahlmodus Flag

  // Globale Einstellung für alternativen Modus
  static bool globalUseAlternativeMotorMode = false;

  // Motor-Mapping
  static const Map<String, int> spiceToMotor = {
    'paprika': 1,
    'kreuzkummel': 2,
    'koriander': 3,
    'pfeffer': 4,
    'oregano': 5,
    'chili': 6,
  };

  bool _isExecuting = false;
  double _currentTargetWeight = 0.0;
  String _lastReceivedWeight = "0";
  Timer? _alternativeMotorTimer; // Timer für alternativen Modus
  bool _isForwardDirection = true; // Aktuelle Richtung im alternativen Modus
  StreamController<String> _statusController = StreamController.broadcast();
  StreamController<double> _progressController = StreamController.broadcast();
  StreamController<double> _targetController = StreamController.broadcast();
  Stream<String> get statusStream => _statusController.stream;
  Stream<double> get progressStream => _progressController.stream;
  Stream<double> get targetStream => _targetController.stream;

  RecipeExecutor(this._bluetooth, {bool debugMode = false})
    : _debugMode = debugMode {
    // Verwende globale Einstellung
    useAlternativeMotorMode = globalUseAlternativeMotorMode;

    // Bluetooth-Daten abonnieren
    _bluetoothDataSubscription = _bluetooth.receivedData.listen((data) {
      _lastReceivedWeight = data.trim();
    });
  }

  Future<void> executeRecipe(String recipeName, [int portions = 1]) async {
    if (_isExecuting) return;

    final recipe = RecipeCatalog.getRecipe(recipeName);
    if (recipe == null) return;

    _isExecuting = true;
    _statusController.add(
      "Rezept $recipeName gestartet (${portions} Portion${portions == 1 ? '' : 'en'})",
    );

    try {
      for (String spice in spiceToMotor.keys) {
        final baseAmount = recipe[spice] ?? 0.0;
        final amount = baseAmount * portions; // Portionsgröße berücksichtigen
        if (amount <= 0) continue;

        await _grindSpice(spice, amount);
        await _tareAndWait();
      }

      _statusController.add("Rezept fertig!");
    } catch (e) {
      _statusController.add("Fehler: $e");
    } finally {
      _isExecuting = false;
    }
  }

  Future<void> _grindSpice(String spice, double targetWeight) async {
    final motorID = spiceToMotor[spice]!;
    _currentTargetWeight = targetWeight;
    _targetController.add(targetWeight);
    _statusController.add("Mahle $spice (${targetWeight}g)");

    if (_debugMode) {
      // Debug-Simulation: 3 Sekunden Mahlvorgang
      await _simulateGrinding(targetWeight);
    } else {
      // Echter Mahlvorgang
      if (useAlternativeMotorMode) {
        // Alternativer Modus mit wechselnder Richtung alle 1s
        await _grindWithAlternativeMode(motorID, targetWeight);
      } else {
        // Normaler Modus (nur vorwärts)
        _bluetooth.sendData("<1;$motorID;$targetWeight>");
        await Future.delayed(Duration(milliseconds: 500));

        // Warten bis Zielgewicht erreicht
        await _waitForTargetWeight(targetWeight);

        // Motor stoppen
        _bluetooth.sendData("<0;$motorID;0>");
        await Future.delayed(Duration(milliseconds: 500));
      }
    }
  }

  Future<void> _simulateGrinding(double targetWeight) async {
    const totalDuration = 3000; // 3 Sekunden
    const updateInterval = 100; // Update alle 100ms
    const steps = totalDuration ~/ updateInterval;

    for (int i = 0; i <= steps && _isExecuting; i++) {
      final progress = i / steps;
      final currentWeight = targetWeight * progress;

      _progressController.add(currentWeight);
      _statusController.add(
        "Mahle... ${currentWeight.toStringAsFixed(1)}g / ${targetWeight.toStringAsFixed(1)}g",
      );

      if (i < steps) {
        await Future.delayed(Duration(milliseconds: updateInterval));
      }
    }
  }

  Future<void> _grindWithAlternativeMode(
    int motorID,
    double targetWeight,
  ) async {
    _isForwardDirection = true; // Beginne mit Vorwärtsrichtung

    // Starte den ersten Motor
    _bluetooth.sendData("<1;$motorID;$targetWeight>");
    await Future.delayed(Duration(milliseconds: 500));

    // Timer für das Wechseln der Richtung alle 1 Sekunde
    _alternativeMotorTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isExecuting) {
        timer.cancel();
        return;
      }

      // Richtung wechseln
      _isForwardDirection = !_isForwardDirection;

      if (_isForwardDirection) {
        // Programm 1: Vorwärts
        _bluetooth.sendData("<1;$motorID;$targetWeight>");
      } else {
        // Programm 4: Rückwärts
        _bluetooth.sendData("<4;$motorID;$targetWeight>");
      }
    });

    // Warten bis Zielgewicht erreicht
    await _waitForTargetWeight(targetWeight);

    // Timer stoppen und Motor stoppen
    _alternativeMotorTimer?.cancel();
    _bluetooth.sendData("<0;$motorID;0>");
    await Future.delayed(Duration(milliseconds: 1000));
  }

  String _getCurrentWeightFromBluetooth() {
    // Prüfe zuerst _lastReceivedWeight
    if (_lastReceivedWeight.isNotEmpty) {
      return _lastReceivedWeight;
    }

    return "0";
  }

  Future<void> _waitForTargetWeight(double targetWeight) async {
    double currentWeight = 0.0;
    int timeoutCount = 0;
    const maxTimeout = 600; // 60 Sekunden maximale Wartezeit

    while (_isExecuting &&
        currentWeight < targetWeight &&
        timeoutCount < maxTimeout) {
      await Future.delayed(Duration(milliseconds: 100));

      // Aktuelles Gewicht aus receivedData holen
      try {
        currentWeight = double.parse(_getCurrentWeightFromBluetooth());
      } catch (e) {
        currentWeight = 0.0;
      }

      timeoutCount++;

      // Progress Update senden
      _progressController.add(currentWeight);

      // Status Update alle 10 Iterationen (1 Sekunde)
      if (timeoutCount % 10 == 0) {
        _statusController.add(
          "Mahle... ${currentWeight.toStringAsFixed(1)}g / ${targetWeight.toStringAsFixed(1)}g",
        );
      }
    }

    if (timeoutCount >= maxTimeout) {
      _statusController.add("Timeout erreicht für ${targetWeight}g");
    }
  }

  Future<void> _tareAndWait() async {
    if (_debugMode) {
      _statusController.add("Tariere Waage...");
      await Future.delayed(Duration(milliseconds: 500)); // Verkürzt für Debug
    } else {
      _statusController.add("Tariere Waage...");
      _bluetooth.sendData("<2;0;0>");
      await Future.delayed(Duration(seconds: 2));
    }
  }

  // Öffentliche Tarierungsmethode
  Future<void> tare() async {
    await _tareAndWait();
  }

  void dispose() {
    _bluetoothDataSubscription?.cancel();
    _alternativeMotorTimer?.cancel();
    _statusController.close();
    _progressController.close();
    _targetController.close();
  }

  void updateProgress(String receivedData) {
    _lastReceivedWeight = receivedData;
    try {
      final currentWeight = double.parse(receivedData);
      _progressController.add(currentWeight);
    } catch (e) {
      // Ignore parsing errors
    }
  }

  double get currentTargetWeight => _currentTargetWeight;

  void stop() {
    _isExecuting = false;
    _alternativeMotorTimer?.cancel();
    _statusController.add("Gestoppt");
  }
}
