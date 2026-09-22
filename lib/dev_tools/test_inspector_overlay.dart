import 'package:flutter/material.dart';
import '../core/constants/app_keys.dart';
import '../core/widgets/testable_widget.dart';

/// Pływający inspektor ułatwiający naukę automatyzacji testów.
/// Pozwala podejrzeć klucze i gotowe selektory dla aktywnego ekranu.
class TestInspectorOverlay extends StatefulWidget {
  final Widget child;
  final String currentRoute;
  final List<String> availableKeys;

  const TestInspectorOverlay({
    super.key,
    required this.child,
    required this.currentRoute,
    this.availableKeys = const [],
  });

  @override
  State<TestInspectorOverlay> createState() => _TestInspectorOverlayState();
}

class _TestInspectorOverlayState extends State<TestInspectorOverlay> {
  bool _isOpen = false;
  String _selectedFramework = 'Flutter Test';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Pływający przycisk otwierający inspektora
        Positioned(
          bottom: 20,
          right: 16,
          child: TestableWidget(
            keyId: AppKeys.toggleInspectorBtn,
            semanticLabel: 'Pokaż selektory testowe dla tego ekranu',
            child: FloatingActionButton.small(
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.black,
              tooltip: 'Pokaż selektory testowe dla tego ekranu',
              onPressed: () {
                setState(() => _isOpen = !_isOpen);
              },
              child: Icon(_isOpen ? Icons.close : Icons.bug_report),
            ),
          ),
        ),
        // Panel inspektora
        if (_isOpen)
          Positioned(
            bottom: 80,
            right: 16,
            left: 16,
            child: Material(
              key: const Key(AppKeys.inspectorOverlayPanel),
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade900,
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(maxHeight: 380),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TestableWidget(
                          keyId: AppKeys.inspectorActiveScreenText,
                          semanticLabel: 'Test Inspector: ${widget.currentRoute}',
                          child: Text(
                            'Test Inspector: ${widget.currentRoute}',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        TestableWidget(
                          keyId: AppKeys.inspectorCloseBtn,
                          semanticLabel: 'Zamknij inspektora',
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 18),
                            onPressed: () => setState(() => _isOpen = false),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24),
                    // Przełącznik frameworka
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _frameworkChip('Flutter Test'),
                          _frameworkChip('Patrol'),
                          _frameworkChip('Maestro'),
                          _frameworkChip('Appium / Pytest'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dostępne selektory dla tego widoku:',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: widget.availableKeys.isEmpty
                          ? const Center(
                              child: Text(
                                'Brak zarejestrowanych kluczy dla tego widoku',
                                style: TextStyle(color: Colors.white38),
                              ),
                            )
                          : ListView.builder(
                              key: const Key(AppKeys.inspectorKeyList),
                              itemCount: widget.availableKeys.length,
                              itemBuilder: (context, index) {
                                final keyName = widget.availableKeys[index];
                                return _buildSelectorTile(keyName);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _frameworkChip(String name) {
    final isSelected = _selectedFramework == name;
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ChoiceChip(
        label: Text(name, style: TextStyle(fontSize: 11, color: isSelected ? Colors.black : Colors.white)),
        selected: isSelected,
        selectedColor: Colors.amber,
        backgroundColor: Colors.grey.shade800,
        onSelected: (val) {
          if (val) setState(() => _selectedFramework = name);
        },
      ),
    );
  }

  Widget _buildSelectorTile(String keyName) {
    String selectorCode = '';
    switch (_selectedFramework) {
      case 'Flutter Test':
        selectorCode = "find.byKey(const Key('$keyName'))";
        break;
      case 'Patrol':
        selectorCode = r'$' + "('$keyName') / " + r'$' + "(#$keyName)";
        break;
      case 'Maestro':
        selectorCode = 'id: "$keyName"';
        break;
      case 'Appium / Pytest':
        selectorCode = 'find_element(AppiumBy.ACCESSIBILITY_ID, "$keyName")';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            keyName,
            style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          SelectableText(
            selectorCode,
            style: const TextStyle(color: Colors.white60, fontSize: 10, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}
