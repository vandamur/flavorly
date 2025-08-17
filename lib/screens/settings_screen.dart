import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import '../services/recipe_executor.dart';
import '../data/recipes.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'dart:async';

class SettingsScreen extends StatefulWidget {
  final BluetoothService bluetoothService;

  const SettingsScreen({super.key, required this.bluetoothService});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final BluetoothService _bluetooth;
  late final RecipeExecutor _recipeExecutor;
  final TextEditingController _textController = TextEditingController();
  String _receivedData = "";
  double _targetWeight = 0.0;
  bool _isTaring = false;
  int _motorID = 1;
  String _selectedRecipe = "muhammara";

  fbp.BluetoothDevice? _connectedDevice;

  // Stream-Subscriptions für ordnungsgemäße Entsorgung
  StreamSubscription<fbp.BluetoothDevice?>? _connectionSubscription;
  StreamSubscription<String>? _dataSubscription;

  @override
  void initState() {
    super.initState();
    _bluetooth = widget.bluetoothService;
    _recipeExecutor = RecipeExecutor(_bluetooth);
    _setupBluetoothListeners();

    // Aktuellen Verbindungsstatus abrufen
    _connectedDevice = _bluetooth.connectedDevice;

    // Keine neue Scan-Session starten - verwende bestehende Verbindung
  }

  void _setupBluetoothListeners() {
    _connectionSubscription = _bluetooth.connectionState.listen((device) {
      if (mounted) {
        setState(() {
          _connectedDevice = device;
        });
      }
    });

    _dataSubscription = _bluetooth.receivedData.listen((data) {
      if (mounted) {
        setState(() {
          _receivedData = data;
        });
        // Update Recipe Executor für Progress
        _recipeExecutor.updateProgress(data);
      }
    });
  }

  void _handleTare() {
    _bluetooth.sendData("<2;0;0>");
    setState(() {
      _isTaring = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTaring = false;
        });
      }
    });
  }

  double _getCurrentWeight() {
    try {
      return double.parse(_receivedData);
    } catch (e) {
      return 0.0;
    }
  }

  @override
  void dispose() {
    // Stream-Subscriptions ordnungsgemäß beenden
    _connectionSubscription?.cancel();
    _dataSubscription?.cancel();
    _recipeExecutor.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _showRecipeTestDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => RecipeTestDialog(
            recipeName: _selectedRecipe,
            recipeExecutor: _recipeExecutor,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Debug')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_connectedDevice == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 10),

            if (_connectedDevice != null) ...[
              // Rezept Test Sektion
              const Text(
                'Rezept Test:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Text('Rezept: '),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedRecipe,
                      items:
                          RecipeCatalog.getAllRecipeNames()
                              .map(
                                (name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRecipe = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _showRecipeTestDialog,
                child: const Text('Rezept Testen'),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter text to send',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _bluetooth.sendData(_textController.text);
                  //_textController.clear();
                },
                child: const Text('Send'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Target Weight: ${_targetWeight.toStringAsFixed(1)} g'),
                  Expanded(
                    child: Slider(
                      value: _targetWeight,
                      min: 0.0,
                      max: 3.0,
                      divisions: 60,
                      onChanged: (value) {
                        setState(() {
                          _targetWeight = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Motor ID:'),
                  DropdownButton<int>(
                    value: _motorID,
                    items:
                        List.generate(6, (index) => index + 1)
                            .map(
                              (id) => DropdownMenuItem(
                                value: id,
                                child: Text(id.toString()),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _motorID = value ?? 1;
                      });
                    },
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _bluetooth.sendData("<1;$_motorID;$_targetWeight>");
                    },
                    child: const Text('Test'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _bluetooth.sendData("<0;$_motorID;0>");
                    },
                    child: const Text('Stop'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _handleTare();
                    },
                    child: const Text('Tare'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Current Weight:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Center(
                child: Text(
                  _isTaring ? 'Taring...' : '$_receivedData g',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 10),
              if (_targetWeight > 0) ...[
                LinearProgressIndicator(
                  value: _getCurrentWeight() / _targetWeight,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                ),
                const SizedBox(height: 20),
              ],
              ElevatedButton(
                onPressed: () {
                  // Step 1: Send tare command
                  _bluetooth.sendData("<2;0;0>");

                  // Show popup for the next step
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Calibration Step'),
                        content: const Text(
                          'Place 10g calibration weight and press Continue.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog

                              // Step 2: Send calibration command
                              _bluetooth.sendData("<3;0;10>");
                            },
                            child: const Text('Continue'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Calibrate with 10g'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class RecipeTestDialog extends StatefulWidget {
  final String recipeName;
  final RecipeExecutor recipeExecutor;

  const RecipeTestDialog({
    super.key,
    required this.recipeName,
    required this.recipeExecutor,
  });

  @override
  State<RecipeTestDialog> createState() => _RecipeTestDialogState();
}

class _RecipeTestDialogState extends State<RecipeTestDialog> {
  String _status = "";
  double _currentWeight = 0.0;
  double _targetWeight = 0.0;
  StreamSubscription? _statusSub;
  StreamSubscription? _progressSub;
  StreamSubscription? _targetSub;

  @override
  void initState() {
    super.initState();

    _statusSub = widget.recipeExecutor.statusStream.listen((status) {
      if (mounted) {
        setState(() {
          _status = status;
        });
      }
    });

    _progressSub = widget.recipeExecutor.progressStream.listen((weight) {
      if (mounted) {
        setState(() {
          _currentWeight = weight;
        });
      }
    });

    _targetSub = widget.recipeExecutor.targetStream.listen((target) {
      if (mounted) {
        setState(() {
          _targetWeight = target;
        });
      }
    });

    // Rezept starten
    widget.recipeExecutor.executeRecipe(widget.recipeName);
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _progressSub?.cancel();
    _targetSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _targetWeight > 0 ? _currentWeight / _targetWeight : 0.0;

    return AlertDialog(
      title: Text('Rezept: ${widget.recipeName}'),
      content: SizedBox(
        width: 300,
        height: 200,
        child: Column(
          children: [
            Text(_status, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            if (_targetWeight > 0) ...[
              Text(
                '${_currentWeight.toStringAsFixed(1)}g / ${_targetWeight.toStringAsFixed(1)}g',
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.recipeExecutor.stop();
            Navigator.of(context).pop();
          },
          child: const Text('Stoppen'),
        ),
        if (_status.contains('fertig'))
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
      ],
    );
  }
}
