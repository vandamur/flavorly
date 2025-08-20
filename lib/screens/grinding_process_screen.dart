import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/bluetooth_service.dart';
import '../services/recipe_executor.dart';
import 'dart:async';

// Popup für Glasplatzierung
class GlassPlacementDialog extends StatefulWidget {
  final String recipeName;
  final int portions;
  final String recipeKey;
  final bool isDebugMode;

  const GlassPlacementDialog({
    super.key,
    required this.recipeName,
    required this.portions,
    required this.recipeKey,
    this.isDebugMode = false,
  });

  @override
  State<GlassPlacementDialog> createState() => _GlassPlacementDialogState();
}

class _GlassPlacementDialogState extends State<GlassPlacementDialog> {
  bool _isProcessing = false;
  String _statusText = 'Das Glas muss auf der markierten Fläche stehen';

  Future<void> _startTareAndGrinding() async {
    setState(() {
      _isProcessing = true;
      _statusText = 'Tariere Waage...';
    });

    // Tarierung durchführen
    final bluetooth = BluetoothService();
    final recipeExecutor = RecipeExecutor(
      bluetooth,
      debugMode: widget.isDebugMode,
    );

    // Tarierung ausführen
    await recipeExecutor.tare();

    setState(() {
      _statusText = 'Vorbereitung läuft...';
    });

    // 2 Sekunden Wartepause
    await Future.delayed(Duration(seconds: 2));

    // RecipeExecutor ordnungsgemäß entsorgen
    recipeExecutor.dispose();

    if (mounted) {
      Navigator.of(context).pop();
      // Navigation zum Mahlvorgang-Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => GrindingProcessScreen(
                recipeName: widget.recipeName,
                portions: widget.portions,
                recipeKey: widget.recipeKey,
                isDebugMode: widget.isDebugMode,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titel
            Text(
              'Bitte Glas platzieren',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Untertitel
            Text(
              _statusText,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.onSurface),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Glas Icon
            Image.asset(
              'assets/glass.png',
              height: 120,
              width: 120,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.local_drink,
                  size: 120,
                  color: AppColors.support,
                );
              },
            ),

            const SizedBox(height: 32),

            // Bestätigungsbutton
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _startTareAndGrinding,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isProcessing ? Colors.grey : AppColors.support,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isProcessing) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      _isProcessing
                          ? 'Vorbereitung...'
                          : 'Ich habe das Glas platziert',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Screen für den Mahlvorgang
class GrindingProcessScreen extends StatefulWidget {
  final String recipeName;
  final int portions;
  final String recipeKey;
  final bool isDebugMode;

  const GrindingProcessScreen({
    super.key,
    required this.recipeName,
    required this.portions,
    required this.recipeKey,
    this.isDebugMode = false,
  });

  @override
  State<GrindingProcessScreen> createState() => _GrindingProcessScreenState();
}

class _GrindingProcessScreenState extends State<GrindingProcessScreen> {
  late BluetoothService _bluetooth;
  late RecipeExecutor _recipeExecutor;
  String _status = "";
  double _currentWeight = 0.0;
  double _targetWeight = 0.0;
  StreamSubscription? _statusSub;
  StreamSubscription? _progressSub;
  StreamSubscription? _targetSub;

  @override
  void initState() {
    super.initState();
    _bluetooth = BluetoothService();
    // Debug-Modus basierend auf dem übergebenen Parameter verwenden
    _recipeExecutor = RecipeExecutor(_bluetooth, debugMode: widget.isDebugMode);
    _setupListeners();
    _startGrinding();
  }

  void _setupListeners() {
    _statusSub = _recipeExecutor.statusStream.listen((status) {
      if (mounted) {
        setState(() {
          _status = status;
        });

        // Zeige Completion-Popup wenn fertig
        if (status.contains('Rezept fertig!')) {
          _showCompletionDialog();
        }
      }
    });

    _progressSub = _recipeExecutor.progressStream.listen((weight) {
      if (mounted) {
        setState(() {
          _currentWeight = weight;
        });
      }
    });

    _targetSub = _recipeExecutor.targetStream.listen((target) {
      if (mounted) {
        setState(() {
          _targetWeight = target;
        });
      }
    });
  }

  void _startGrinding() {
    // Starte den Mahlvorgang für das angepasste Rezept mit Portionsgröße
    _recipeExecutor.executeRecipe(widget.recipeKey, widget.portions);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Erfolgs-Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.support,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Titel
                  Text(
                    'Herzlichen Glückwunsch!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Nachricht
                  Text(
                    'Deine Rezeptmischung ist fertig.\nBis zum nächsten Mal!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Zurück zum Start Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Schließe alle Screens und gehe zurück zum Start
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Zurück zum Start',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _progressSub?.cancel();
    _targetSub?.cancel();
    _recipeExecutor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _targetWeight > 0 ? _currentWeight / _targetWeight : 0.0;
    final isFinished = _status.contains('fertig');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Mahlvorgang - ${widget.recipeName}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.only(left: 24),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // Header Info
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.recipeName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.portions} Portion${widget.portions == 1 ? '' : 'en'}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Status
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _status.isEmpty ? 'Starte Mahlvorgang...' : _status,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Progress nur anzeigen wenn Zielgewicht > 0
              if (_targetWeight > 0) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Fortschritt',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_currentWeight.toStringAsFixed(1)}g / ${_targetWeight.toStringAsFixed(1)}g',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 12,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isFinished ? AppColors.support : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              const Spacer(),

              // Action Buttons
              if (isFinished) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(); // Zurück zur Recipe Detail
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.support,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Fertig!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _recipeExecutor.stop();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Abbrechen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
