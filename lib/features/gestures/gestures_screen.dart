import 'package:flutter/material.dart';
import '../../core/constants/app_keys.dart';
import '../../core/widgets/testable_widget.dart';
import '../../dev_tools/test_inspector_overlay.dart';

class GesturesScreen extends StatefulWidget {
  const GesturesScreen({super.key});

  @override
  State<GesturesScreen> createState() => _GesturesScreenState();
}

class _GesturesScreenState extends State<GesturesScreen> {
  // Liczniki tapnięć
  int _singleTapCount = 0;
  int _doubleTapCount = 0;
  String _longPressMessage = 'Przytrzymaj obszar (Long Press)';

  // Reorderable list
  final List<String> _reorderableItems = [
    'Zadanie 1: Przygotuj środowisko testowe',
    'Zadanie 2: Napisz testy jednostkowe',
    'Zadanie 3: Skonfiguruj CI/CD pipeline',
    'Zadanie 4: Uruchom testy integracyjne',
  ];

  // Drag & drop box
  int _dragScore = 0;
  bool _isItemInTransit = false;

  // Swipe to dismiss
  final List<String> _swipeItems = [
    'Element A (Przesuń w lewo aby usunąć)',
    'Element B (Przesuń w prawo aby zarchiwizować)',
    'Element C (Przesuń w dowolną stronę)',
    'Element D (Wymaga potwierdzenia)',
  ];

  // Signature canvas
  final List<Offset?> _points = [];

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.gesturesSingleTapArea,
      AppKeys.gesturesSingleTapCounter,
      AppKeys.gesturesDoubleTapArea,
      AppKeys.gesturesDoubleTapCounter,
      AppKeys.gesturesLongPressArea,
      AppKeys.gesturesLongPressFeedback,
      AppKeys.gesturesReorderableList,
      AppKeys.gesturesDraggableItem,
      AppKeys.gesturesDragTargetBin,
      AppKeys.gesturesDragScoreText,
      AppKeys.gesturesSwipeDismissibleList,
      AppKeys.gesturesInteractiveViewer,
      AppKeys.gesturesCanvasSignature,
      AppKeys.gesturesCanvasClearBtn,
    ];

    return TestInspectorOverlay(
      currentRoute: '/gestures',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.gesturesScreen),
        appBar: AppBar(title: const Text('Gesty & Interakcje Dotykowe')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Podstawowe gesty tapnięć
              _buildSectionTitle('1. Tapnięcia, Podwójne Tapnięcia i Long Press'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TestableWidget(
                      keyId: AppKeys.gesturesSingleTapArea,
                      semanticLabel: 'Pojedynczy Tap',
                      child: GestureDetector(
                        onTap: () => setState(() => _singleTapCount++),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.touch_app, color: Colors.blue),
                              const SizedBox(height: 6),
                              const Text('Pojedynczy Tap', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              TestableWidget(
                                keyId: AppKeys.gesturesSingleTapCounter,
                                semanticLabel: 'Licznik: $_singleTapCount',
                                child: Text(
                                  'Licznik: $_singleTapCount',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TestableWidget(
                      keyId: AppKeys.gesturesDoubleTapArea,
                      semanticLabel: 'Podwójny Tap',
                      child: GestureDetector(
                        onDoubleTap: () => setState(() => _doubleTapCount++),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.teal),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.touch_app_outlined, color: Colors.teal),
                              const SizedBox(height: 6),
                              const Text('Podwójny Tap', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              TestableWidget(
                                keyId: AppKeys.gesturesDoubleTapCounter,
                                semanticLabel: 'Licznik: $_doubleTapCount',
                                child: Text(
                                  'Licznik: $_doubleTapCount',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TestableWidget(
                keyId: AppKeys.gesturesLongPressArea,
                semanticLabel: 'Obszar Long Press',
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _longPressMessage = 'SUKCES: Wykryto Long Press! (${DateTime.now().second}s)';
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade800),
                    ),
                    child: Center(
                      child: TestableWidget(
                        keyId: AppKeys.gesturesLongPressFeedback,
                        semanticLabel: _longPressMessage,
                        child: Text(
                          _longPressMessage,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Drag & Drop do celu (Draggable & DragTarget)
              _buildSectionTitle('2. Przeciągnij i Upuść (Draggable & DragTarget)'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TestableWidget(
                    keyId: AppKeys.gesturesDraggableItem,
                    semanticLabel: 'Klocek do Przeciągnięcia',
                    child: Draggable<int>(
                      data: 1,
                      feedback: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.purple.shade400,
                          child: const Text('Przeciągany Klocek', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      childWhenDragging: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Klocek w locie...', style: TextStyle(color: Colors.black38)),
                      ),
                      onDragStarted: () => setState(() => _isItemInTransit = true),
                      onDragEnd: (details) => setState(() => _isItemInTransit = false),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          border: Border.all(color: Colors.purple),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Klocek do Przeciągnięcia', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  TestableWidget(
                    keyId: AppKeys.gesturesDragTargetBin,
                    semanticLabel: 'Kosz Docelowy',
                    child: DragTarget<int>(
                      builder: (context, candidateData, rejectedData) {
                        final isHovered = candidateData.isNotEmpty;
                        return Container(
                          height: 100,
                          width: 140,
                          decoration: BoxDecoration(
                            color: isHovered ? Colors.green.shade200 : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green, width: isHovered ? 3 : 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.archive, color: Colors.green),
                              const Text('Kosz Docelowy', style: TextStyle(fontWeight: FontWeight.bold)),
                              TestableWidget(
                                keyId: AppKeys.gesturesDragScoreText,
                                semanticLabel: 'Trafień: $_dragScore',
                                child: Text('Trafień: $_dragScore'),
                              ),
                            ],
                          ),
                        );
                      },
                      onAcceptWithDetails: (details) {
                        setState(() => _dragScore += details.data);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Upuszczono klocek w koszu! +1 punkt')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. ReorderableListView
              _buildSectionTitle('3. Zmiana Kolejności Listy (ReorderableListView)'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ReorderableListView.builder(
                  key: const Key(AppKeys.gesturesReorderableList),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _reorderableItems.length,
                  itemBuilder: (context, index) {
                    final item = _reorderableItems[index];
                    return ListTile(
                      key: ValueKey(AppKeys.gesturesReorderableItem(index)),
                      leading: const Icon(Icons.drag_handle),
                      title: Text(item),
                      trailing: Text('#${index + 1}'),
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) newIndex -= 1;
                      final item = _reorderableItems.removeAt(oldIndex);
                      _reorderableItems.insert(newIndex, item);
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 4. Swipe to Dismiss
              _buildSectionTitle('4. Przesuń aby Usunąć (Swipe to Dismiss)'),
              const SizedBox(height: 8),
              ListView.builder(
                key: const Key(AppKeys.gesturesSwipeDismissibleList),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _swipeItems.length,
                itemBuilder: (context, index) {
                  final item = _swipeItems[index];
                  return Dismissible(
                    key: ValueKey(AppKeys.gesturesSwipeItem(index)),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.archive, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Usuwanie - zapytaj o potwierdzenie
                        return await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Potwierdzenie usunięcia'),
                            content: Text('Czy na pewno chcesz usunąć "$item"?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Anuluj')),
                              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Usuń')),
                            ],
                          ),
                        );
                      }
                      return true;
                    },
                    onDismissed: (direction) {
                      setState(() {
                        _swipeItems.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Element został usunięty / przeniesiony')),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.swipe),
                        title: Text(item),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 5. InteractiveViewer (Zoom & Pan)
              _buildSectionTitle('5. Przybliżanie i Przesuwanie (Pinch-to-Zoom & Pan)'),
              const SizedBox(height: 8),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: InteractiveViewer(
                    key: const Key(AppKeys.gesturesInteractiveViewer),
                    boundaryMargin: const EdgeInsets.all(20),
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.zoom_in, size: 48, color: Colors.amber),
                          SizedBox(height: 8),
                          Text(
                            'Przybliż dwoma palcami (Pinch) lub przesuń',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text('Siatka testowa: [ X: 100, Y: 200 ]', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 6. Canvas / Podpis
              _buildSectionTitle('6. Rysowanie i Podpis Gestem (Touch Canvas)'),
              const SizedBox(height: 8),
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  key: const Key(AppKeys.gesturesCanvasSignature),
                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      _points.add(details.localPosition);
                    });
                  },
                  onPanEnd: (details) => _points.add(null),
                  child: CustomPaint(
                    painter: _SignaturePainter(_points),
                    size: Size.infinite,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TestableWidget(
                keyId: AppKeys.gesturesCanvasClearBtn,
                semanticLabel: 'Wyczyść pole podpisu',
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.clear),
                  label: const Text('Wyczyść pole podpisu'),
                  onPressed: () => setState(() => _points.clear()),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.indigo),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
