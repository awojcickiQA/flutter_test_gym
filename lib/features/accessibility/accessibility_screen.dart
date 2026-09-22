import 'package:flutter/material.dart';
import '../../core/constants/app_keys.dart';
import '../../core/widgets/testable_widget.dart';
import '../../dev_tools/test_inspector_overlay.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool _isRTL = false;
  bool _highContrast = false;
  int _challengeCounter = 0;
  bool _semanticsTapped = false;

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.a11yLanguageToggleBtn,
      AppKeys.a11yCurrentDirectionText,
      AppKeys.a11yHighContrastToggle,
      AppKeys.a11ySemanticsCard,
    ];

    return Directionality(
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: TestInspectorOverlay(
        currentRoute: '/accessibility',
        availableKeys: availableKeys,
        child: Scaffold(
          key: const Key(AppKeys.a11yScreen),
          appBar: AppBar(
            title: const Text('Dostępność & Edge Cases'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Obsługa kierunku tekstu (LTR vs RTL)
                _buildSectionHeader('1. Kierunek Tekstu i Układu (LTR vs RTL - np. Arabski/Hebrajski)'),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TestableWidget(
                          keyId: AppKeys.a11yCurrentDirectionText,
                          semanticLabel: 'Bieżący kierunek: ${_isRTL ? "RTL (Prawa do Lewej)" : "LTR (Lewa do Prawej)"}',
                          child: Text(
                            'Bieżący kierunek: ${_isRTL ? "RTL (Prawa do Lewej)" : "LTR (Lewa do Prawej)"}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TestableWidget(
                          keyId: AppKeys.a11yLanguageToggleBtn,
                          semanticLabel: _isRTL ? 'Przełącz na LTR (Polski/Angielski)' : 'Przełącz na RTL (Arabski)',
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.translate),
                            label: Text(_isRTL ? 'Przełącz na LTR (Polski/Angielski)' : 'Przełącz na RTL (Arabski)'),
                            onPressed: () => setState(() => _isRTL = !_isRTL),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(Icons.arrow_back),
                          title: Text(_isRTL ? 'هذا نص تجريبي باللغة العربية' : 'Przykładowy wiersz z ikoną kierunkową'),
                          trailing: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TestableWidget(
                  keyId: AppKeys.a11yHighContrastToggle,
                  semanticLabel: 'Tryb wysokiego kontrastu',
                  child: SwitchListTile(
                    title: const Text('Tryb wysokiego kontrastu (High Contrast)'),
                    value: _highContrast,
                    onChanged: (val) => setState(() => _highContrast = val),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Semantics Tree Audit
                _buildSectionHeader('2. Drzewo Semantyki (Semantics & Accessibility Audit)'),
                const SizedBox(height: 8),
                Semantics(
                  identifier: AppKeys.a11ySemanticsCard,
                  key: const Key(AppKeys.a11ySemanticsCard),
                  label: 'Karta dostępności dla czytników ekranu',
                  hint: 'Podwójne stuknięcie aktywuje ten element',
                  value: _semanticsTapped ? 'Zaznaczona' : 'Niezaznaczona',
                  button: true,
                  child: InkWell(
                    onTap: () => setState(() => _semanticsTapped = !_semanticsTapped),
                    child: Card(
                      color: _semanticsTapped ? Colors.indigo.shade100 : Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(_semanticsTapped ? Icons.check_box : Icons.check_box_outline_blank),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Dedykowany widżet z etykietą Semantics', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(
                                    'Ten kafelek posiada parametry label, hint i value odczytywane przez TalkBack/VoiceOver oraz Maestro.',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Wyzwanie "Brakujące Klucze" (Missing Keys Challenge)
                _buildSectionHeader('3. Wyzwanie: Brakujące Klucze (Missing Keys Challenge)'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    border: Border.all(color: Colors.amber.shade800),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Poniższa sekcja CELOWO nie posiada żadnego `Key` ani `ValueKey`. '
                    'Zadanie testowe: Zlokalizuj przycisk ze strzałką w górę wewnątrz karty "Serwer B" za pomocą relacji przodek-potomek (`find.descendant` / `find.ancestor`) lub tekstu i zwiększ licznik!',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Elementy bez kluczy:
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Węzeł Produkcyjny: Serwer A', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text('Stan: Aktywny • Obciążenie: 24%'),
                        Row(
                          children: [
                            IconButton(icon: const Icon(Icons.power_settings_new), onPressed: () {}),
                            const Text('Restartuj Serwer A'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Węzeł Produkcyjny: Serwer B', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Licznik zgłoszeń: $_challengeCounter'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_upward),
                              onPressed: () => setState(() => _challengeCounter++),
                            ),
                            const Text('Zwiększ licznik zgłoszeń Serwera B'),
                          ],
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
