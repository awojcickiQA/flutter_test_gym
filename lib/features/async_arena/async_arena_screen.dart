import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_keys.dart';
import '../../core/widgets/testable_widget.dart';
import '../../dev_tools/test_inspector_overlay.dart';

class AsyncArenaScreen extends StatefulWidget {
  const AsyncArenaScreen({super.key});

  @override
  State<AsyncArenaScreen> createState() => _AsyncArenaScreenState();
}

class _AsyncArenaScreenState extends State<AsyncArenaScreen> with SingleTickerProviderStateMixin {
  // 1. Opóźnienia sieciowe
  int _simulatedDelaySeconds = 1;
  bool _isLoadingData = false;
  String? _loadedResult;

  // 2. Pułapka pumpAndSettle (nieskończona animacja)
  late AnimationController _animController;
  bool _isAnimationRunning = true;

  // 3. Flaky Button
  int _flakyAttempts = 0;
  bool? _flakySuccess; // null = nieuruchomiony, true = sukces, false = błąd 500

  // 4. Transient message (auto-znikający baner)
  bool _showTransientToast = false;
  Timer? _transientTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    _transientTimer?.cancel();
    super.dispose();
  }

  void _fetchAsyncData() async {
    setState(() {
      _isLoadingData = true;
      _loadedResult = null;
    });

    await Future.delayed(Duration(seconds: _simulatedDelaySeconds));
    if (!mounted) return;

    setState(() {
      _isLoadingData = false;
      _loadedResult = 'Dane pomyślnie pobrane po ${_simulatedDelaySeconds}s! Token: AUTH-${Random().nextInt(99999)}';
    });
  }

  void _toggleAnimation() {
    setState(() {
      if (_isAnimationRunning) {
        _animController.stop();
        _isAnimationRunning = false;
      } else {
        _animController.repeat();
        _isAnimationRunning = true;
      }
    });
  }

  void _triggerFlakyAction() async {
    setState(() {
      _flakyAttempts++;
      _flakySuccess = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    // 40% szans na błąd przy pierwszych próbach
    final isError = Random().nextDouble() < 0.45;
    setState(() {
      _flakySuccess = !isError;
    });
  }

  void _triggerTransientToast() {
    _transientTimer?.cancel();
    setState(() => _showTransientToast = true);

    _transientTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showTransientToast = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.asyncDelaySelectorSegment,
      AppKeys.asyncFetchDataBtn,
      AppKeys.asyncLoadingSpinner,
      AppKeys.asyncResultText,
      AppKeys.asyncInfiniteAnimationWidget,
      AppKeys.asyncAnimationToggleBtn,
      AppKeys.asyncFlakyBtn,
      AppKeys.asyncFlakySuccessBadge,
      AppKeys.asyncFlakyErrorBadge,
      AppKeys.asyncFlakyRetryBtn,
      AppKeys.asyncTriggerToastBtn,
      AppKeys.asyncTransientToast,
    ];

    return TestInspectorOverlay(
      currentRoute: '/async',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.asyncScreen),
        appBar: AppBar(title: const Text('Asynchroniczność & Flakiness Arena')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sekcja 1: Konfigurowalne opóźnienia sieciowe
              _buildSectionHeader('1. Symulowane Opóźnienia Sieciowe (Delays)'),
              const SizedBox(height: 8),
              const Text('Wybierz czas odpowiedzi serwera:'),
              const SizedBox(height: 6),
              SegmentedButton<int>(
                key: const Key(AppKeys.asyncDelaySelectorSegment),
                segments: const [
                  ButtonSegment(value: 0, label: Text('0s (Fast)')),
                  ButtonSegment(value: 1, label: Text('1s (Norm)')),
                  ButtonSegment(value: 3, label: Text('3s (Slow)')),
                  ButtonSegment(value: 5, label: Text('5s (Lag)')),
                ],
                selected: {_simulatedDelaySeconds},
                onSelectionChanged: (set) => setState(() => _simulatedDelaySeconds = set.first),
              ),
              const SizedBox(height: 12),
              TestableWidget(
                keyId: AppKeys.asyncFetchDataBtn,
                semanticLabel: 'Wyślij żądanie (${_simulatedDelaySeconds}s)',
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_download),
                  label: Text('Wyślij żądanie (${_simulatedDelaySeconds}s)'),
                  onPressed: _isLoadingData ? null : _fetchAsyncData,
                ),
              ),
              const SizedBox(height: 12),
              if (_isLoadingData) ...[
                Row(
                  children: [
                    TestableWidget(
                      keyId: AppKeys.asyncLoadingSpinner,
                      semanticLabel: 'Oczekiwanie na odpowiedź API...',
                      child: const CircularProgressIndicator(),
                    ),
                    const SizedBox(width: 12),
                    const Text('Oczekiwanie na odpowiedź API...'),
                  ],
                ),
              ] else if (_loadedResult != null) ...[
                TestableWidget(
                  keyId: AppKeys.asyncResultText,
                  semanticLabel: _loadedResult!,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _loadedResult!,
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Sekcja 2: Pułapka pumpAndSettle
              _buildSectionHeader('2. Pułapka "pumpAndSettle" (Nieskończona animacja)'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  border: Border.all(color: Colors.amber.shade800),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'W teście Fluttera wywołanie tester.pumpAndSettle() zawiesza się na tym ekranie z powodu nieustannego obrotu kontrolera. '
                  'Prawidłowe podejście: użyj tester.pump(Duration(seconds: 1)) lub zatrzymaj animację.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  RotationTransition(
                    key: const Key(AppKeys.asyncInfiniteAnimationWidget),
                    turns: _animController,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.sync, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TestableWidget(
                    keyId: AppKeys.asyncAnimationToggleBtn,
                    semanticLabel: _isAnimationRunning ? 'Zatrzymaj animację' : 'Wznów animację',
                    child: ElevatedButton(
                      onPressed: _toggleAnimation,
                      child: Text(_isAnimationRunning ? 'Zatrzymaj animację' : 'Wznów animację'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sekcja 3: Flaky Button (Losowe błędy 500 i retry)
              _buildSectionHeader('3. Niestabilny Przycisk (Flaky Button - 40% szans na 500)'),
              const SizedBox(height: 8),
              Text('Liczba prób: $_flakyAttempts'),
              const SizedBox(height: 6),
              Row(
                children: [
                  TestableWidget(
                    keyId: AppKeys.asyncFlakyBtn,
                    semanticLabel: 'Wykonaj niestabilną akcję',
                    child: ElevatedButton(
                      onPressed: _triggerFlakyAction,
                      child: const Text('Wykonaj niestabilną akcję'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_flakySuccess == false)
                    TestableWidget(
                      keyId: AppKeys.asyncFlakyRetryBtn,
                      semanticLabel: 'Ponów (Retry)',
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Ponów (Retry)'),
                        onPressed: _triggerFlakyAction,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (_flakySuccess == true)
                const TestableWidget(
                  keyId: AppKeys.asyncFlakySuccessBadge,
                  semanticLabel: 'Status 200: Sukces operacji!',
                  child: Chip(
                    avatar: Icon(Icons.check, color: Colors.white),
                    backgroundColor: Colors.green,
                    label: Text('Status 200: Sukces operacji!', style: TextStyle(color: Colors.white)),
                  ),
                )
              else if (_flakySuccess == false)
                const TestableWidget(
                  keyId: AppKeys.asyncFlakyErrorBadge,
                  semanticLabel: 'Błąd 500: Serwer przeciążony! Wymagane ponowienie.',
                  child: Chip(
                    avatar: Icon(Icons.error_outline, color: Colors.white),
                    backgroundColor: Colors.red,
                    label: Text('Błąd 500: Serwer przeciążony! Wymagane ponowienie.', style: TextStyle(color: Colors.white)),
                  ),
                ),
              const SizedBox(height: 24),

              // Sekcja 4: Krótkotrwały komunikat (Auto-dismissing)
              _buildSectionHeader('4. Krótkotrwały Komunikat (Znika po 2 sekundach)'),
              const SizedBox(height: 8),
              TestableWidget(
                keyId: AppKeys.asyncTriggerToastBtn,
                semanticLabel: 'Pokaż komunikat (2s TTL)',
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.timer),
                  label: const Text('Pokaż komunikat (2s TTL)'),
                  onPressed: _triggerTransientToast,
                ),
              ),
              const SizedBox(height: 8),
              if (_showTransientToast)
                TestableWidget(
                  keyId: AppKeys.asyncTransientToast,
                  semanticLabel: 'Wiadomość zniknie za chwilę...',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.info, color: Colors.cyanAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Wiadomość zniknie za chwilę...',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo),
      ),
    );
  }
}
