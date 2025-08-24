import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/bluetooth_service.dart';
import '../services/recipe_executor.dart';
import '../overview.dart';
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

enum _DialogPhase { placement, taring, grinding, finished }

class _GlassPlacementDialogState extends State<GlassPlacementDialog> {
  _DialogPhase _phase = _DialogPhase.placement;
  late BluetoothService _bluetooth;
  RecipeExecutor? _recipeExecutor;
  String _status = '';
  double _currentWeight = 0.0;
  double _targetWeight = 0.0;
  StreamSubscription? _statusSub;
  StreamSubscription? _progressSub;
  StreamSubscription? _targetSub;
  bool _cancelRequested = false;

  // QR Code Mapping
  static const Map<String, String> _qrMap = {
    'auberginen': 'assets/qr_codes/auberginen_qr.png',
    'baba_ganoush': 'assets/qr_codes/baba_ganoush_qr.png',
    'barbacoa': 'assets/qr_codes/barbacoa_qr.png',
    'cowboy_caviar': 'assets/qr_codes/cowboy_caviar_qr.png',
    'doener': 'assets/qr_codes/pilz_doener_qr.png',
    'empanadas': 'assets/qr_codes/empanadas_qr.png',
    'feta_aufstrich': 'assets/qr_codes/feta_aufstrich_qr.png',
    'feuertopf': 'assets/qr_codes/feuertopf_qr.png',
    'ful_medames': 'assets/qr_codes/ful_medames_qr.png',
    'koefte': 'assets/qr_codes/koefte_qr.png',
    'muhammara': 'assets/qr_codes/muhammara_qr.png',
    'paprika_feta_dip': 'assets/qr_codes/paprika_feta_dip_qr.png',
    'picadillo': 'assets/qr_codes/picadillo_qr.png',
    'puten_gyros': 'assets/qr_codes/puten_gyros_qr.png',
    'ropa_vieja': 'assets/qr_codes/ropa_veja_qr.png',
    'salsa_roja': 'assets/qr_codes/salsa_roja_qr.png',
    'tex_mex': 'assets/qr_codes/texmex_qr.png',
    'tintenfisch': 'assets/qr_codes/tintenfisch_qr.png',
    'tomatensosse': 'assets/qr_codes/tomatensosse_qr.png',
    'zucchini_pfanne': 'assets/qr_codes/zucchini_qr.png',
  };

  @override
  void initState() {
    super.initState();
    _bluetooth = BluetoothService();
  }

  Future<void> _startProcess() async {
    if (_phase != _DialogPhase.placement) return;
    setState(() => _phase = _DialogPhase.taring);

    _recipeExecutor = RecipeExecutor(_bluetooth, debugMode: widget.isDebugMode);
    _listenStreams();

    // Tare
    await _recipeExecutor!.tare();
    if (!mounted || _cancelRequested) return;
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _phase = _DialogPhase.grinding);
    _recipeExecutor!.executeRecipe(widget.recipeKey, widget.portions);
  }

  void _listenStreams() {
    _statusSub = _recipeExecutor!.statusStream.listen((s) {
      if (!mounted) return;
      setState(() => _status = s);
      if (s.contains('Rezept fertig!')) {
        setState(() => _phase = _DialogPhase.finished);
      }
    });
    _progressSub = _recipeExecutor!.progressStream.listen((w) {
      if (!mounted) return;
      setState(() => _currentWeight = w);
    });
    _targetSub = _recipeExecutor!.targetStream.listen((t) {
      if (!mounted) return;
      setState(() => _targetWeight = t);
    });
  }

  double get _progress =>
      _targetWeight > 0
          ? (_currentWeight / _targetWeight).clamp(0.0, 1.0)
          : 0.0;

  Future<void> _navigateBack() async {
    // Optional nochmal tarieren
    try {
      await _recipeExecutor?.tare();
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => OverviewScreen(isDebugMode: widget.isDebugMode),
      ),
      (route) => false,
    );
  }

  void _cancel() {
    _cancelRequested = true;
    _recipeExecutor?.stop();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _progressSub?.cancel();
    _targetSub?.cancel();
    _recipeExecutor?.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    switch (_phase) {
      case _DialogPhase.placement:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bitte Glas platzieren',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Das Glas muss auf der markierten Fläche stehen',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.onSurface),
            ),
            const SizedBox(height: 32),
            Image.asset(
              'assets/glass.png',
              height: 120,
              width: 120,
              errorBuilder:
                  (_, __, ___) => Icon(
                    Icons.local_drink,
                    size: 120,
                    color: AppColors.support,
                  ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startProcess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.support,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ich habe das Glas platziert',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        );
      case _DialogPhase.taring:
        return _buildProgressSection(title: 'Waage wird tariert');
      case _DialogPhase.grinding:
        return _buildGrindingSection();
      case _DialogPhase.finished:
        return _buildFinishedSection();
    }
  }

  Widget _buildProgressSection({required String title}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(),
        const SizedBox(height: 32),
        Text(
          _status.isEmpty ? 'Bitte warten...' : _status,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _cancel,
            child: const Text('Abbrechen'),
          ),
        ),
      ],
    );
  }

  Widget _buildGrindingSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Mahlvorgang für ${widget.recipeName} läuft',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          _status.isNotEmpty ? _status : 'Mahle ${widget.recipeName}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        if (_targetWeight > 0) ...[
          Text(
            '${_currentWeight.toStringAsFixed(1)}g / ${_targetWeight.toStringAsFixed(1)}g',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _progress,
            minHeight: 12,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation(AppColors.support),
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 24),
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton(
        //     onPressed: _cancel,
        //     child: const Text('Abbrechen'),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFinishedSection() {
    final qrPath = _qrMap[widget.recipeKey];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zeige sowohl den gemappten als auch einen Test-QR
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                qrPath!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code, size: 60, color: Colors.red),
                      Text('Fehler: $qrPath', style: TextStyle(fontSize: 10)),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                'Scanne für das Rezept\nund die Einkaufsliste!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        Text(
          'Deine Gewürzmischung ist fertig!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Bitte Glas entnehmen',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _navigateBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Neues Rezept wählen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(32),
          child: _buildBody(),
        ),
      ),
    );
  }
}
