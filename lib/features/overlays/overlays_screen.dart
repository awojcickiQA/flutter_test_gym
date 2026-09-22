import 'package:flutter/material.dart';
import '../../core/constants/app_keys.dart';
import '../../core/widgets/testable_widget.dart';
import '../../dev_tools/test_inspector_overlay.dart';

class OverlaysScreen extends StatefulWidget {
  const OverlaysScreen({super.key});

  @override
  State<OverlaysScreen> createState() => _OverlaysScreenState();
}

class _OverlaysScreenState extends State<OverlaysScreen> {
  String _dialogResult = 'Brak wykonanych akcji dialogowych';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSimpleAlert() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key(AppKeys.overlaysAlertDialog),
        title: const Text('Komunikat Systemowy'),
        content: const Text('To jest prosty dialog informacyjny.'),
        actions: [
          TestableWidget(
            keyId: AppKeys.overlaysAlertOkBtn,
            semanticLabel: 'Rozumiem (OK)',
            child: TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() => _dialogResult = 'Zamknięto prosty alert przyciskiem OK');
              },
              child: const Text('Rozumiem (OK)'),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key(AppKeys.overlaysConfirmDialog),
        title: const Text('Potwierdzenie operacji'),
        content: const Text('Czy chcesz zapisać zmiany w konfiguracji?'),
        actions: [
          TestableWidget(
            keyId: AppKeys.overlaysConfirmNoBtn,
            semanticLabel: 'Nie (Anuluj)',
            child: TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Nie (Anuluj)'),
            ),
          ),
          TestableWidget(
            keyId: AppKeys.overlaysConfirmYesBtn,
            semanticLabel: 'Tak (Zapisz)',
            child: ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Tak (Zapisz)'),
            ),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _dialogResult = result ? 'Wybrano: TAK (Zatwierdzono)' : 'Wybrano: NIE (Odrzucono)';
      });
    }
  }

  void _showPromptDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        key: const Key(AppKeys.overlaysPromptDialog),
        title: const Text('Wprowadź kod autoryzacji'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Wpisz "CONFIRM" aby autoryzować:'),
            const SizedBox(height: 8),
            TestableWidget(
              keyId: AppKeys.overlaysPromptInput,
              semanticLabel: 'Wprowadź kod autoryzacji',
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'np. CONFIRM'),
              ),
            ),
          ],
        ),
        actions: [
          TestableWidget(
            keyId: AppKeys.overlaysPromptSubmitBtn,
            semanticLabel: 'Zatwierdź kod autoryzacji',
            child: ElevatedButton(
              onPressed: () {
                final text = controller.text;
                Navigator.of(ctx).pop();
                setState(() {
                  _dialogResult = text == 'CONFIRM'
                      ? 'Sukces: Wprowadzono poprawny kod autoryzacji!'
                      : 'Błąd: Niepoprawny kod ("$text")';
                });
              },
              child: const Text('Zatwierdź'),
            ),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        key: const Key(AppKeys.overlaysBottomSheet),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dolny Arkusz (Modal Bottom Sheet)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Ten komponent często pojawia się w aplikacjach mobilnych jako menu akcji lub filtr.'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Udostępnij wynik testu'),
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() => _dialogResult = 'Wybrano udostępnienie z arkusza dolnego');
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Pobierz raport PDF'),
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() => _dialogResult = 'Wybrano pobranie raportu');
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: TestableWidget(
                keyId: AppKeys.overlaysBottomSheetCloseBtn,
                semanticLabel: 'Zamknij Arkusz',
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Zamknij Arkusz'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbarWithAction() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Element został przeniesiony do kosza.'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          key: const Key(AppKeys.overlaysSnackbarActionBtn),
          label: 'COFNIJ',
          textColor: Colors.amber,
          onPressed: () {
            setState(() => _dialogResult = 'Kliknięto akcję COFNIJ w SnackBarze');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.overlaysShowAlertBtn,
      AppKeys.overlaysShowConfirmBtn,
      AppKeys.overlaysShowPromptBtn,
      AppKeys.overlaysShowBottomSheetBtn,
      AppKeys.overlaysShowSnackbarBtn,
      AppKeys.overlaysOpenDrawerBtn,
      AppKeys.overlaysAlertDialog,
      AppKeys.overlaysConfirmDialog,
      AppKeys.overlaysPromptDialog,
      AppKeys.overlaysDialogResultText,
      AppKeys.overlaysBottomSheet,
    ];

    return TestInspectorOverlay(
      currentRoute: '/overlays',
      availableKeys: availableKeys,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Dialogi, Modale & Nakładki'),
        ),
        drawer: TestableWidget(
          keyId: AppKeys.overlaysNavDrawer,
          semanticLabel: 'Boczne Menu Nawigacyjne (Drawer)',
          child: Drawer(
            key: const Key(AppKeys.overlaysNavDrawer),
            child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.indigo),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.menu_open, color: Colors.white, size: 36),
                    SizedBox(height: 8),
                    Text('Boczne Menu (Drawer)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Powrót do strony głównej'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_box),
                title: const Text('Zaznacz opcję w drawerze'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() => _dialogResult = 'Kliknięto element wewnątrz Drawer menu!');
                },
              ),
            ],
          ),
        ),
      ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wynik ostatniej akcji
              Card(
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.indigo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Status ostatniej akcji dialogowej:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            TestableWidget(
                              keyId: AppKeys.overlaysDialogResultText,
                              semanticLabel: _dialogResult,
                              child: Text(
                                _dialogResult,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Przyciski wywołujące dialogi
              _buildSectionTitle('1. Standardowe Okna Dialogowe (Dialogs)'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  TestableWidget(
                    keyId: AppKeys.overlaysShowAlertBtn,
                    semanticLabel: 'Alert Dialog (Info)',
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.notification_important),
                      label: const Text('Alert Dialog (Info)'),
                      onPressed: _showSimpleAlert,
                    ),
                  ),
                  TestableWidget(
                    keyId: AppKeys.overlaysShowConfirmBtn,
                    semanticLabel: 'Confirmation Dialog (Tak/Nie)',
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.question_answer),
                      label: const Text('Confirmation Dialog (Tak/Nie)'),
                      onPressed: _showConfirmDialog,
                    ),
                  ),
                  TestableWidget(
                    keyId: AppKeys.overlaysShowPromptBtn,
                    semanticLabel: 'Prompt Dialog (Wpisz kod)',
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Prompt Dialog (Wpisz kod)'),
                      onPressed: _showPromptDialog,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('2. Arkusze Dolne (Bottom Sheets) & Paski Powiadomień'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  TestableWidget(
                    keyId: AppKeys.overlaysShowBottomSheetBtn,
                    semanticLabel: 'Pokaż Modal Bottom Sheet',
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.vertical_align_top),
                      label: const Text('Pokaż Modal Bottom Sheet'),
                      onPressed: _showModalBottomSheet,
                    ),
                  ),
                  TestableWidget(
                    keyId: AppKeys.overlaysShowSnackbarBtn,
                    semanticLabel: 'SnackBar z Akcją (Undo)',
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.message),
                      label: const Text('SnackBar z Akcją (Undo)'),
                      onPressed: _showSnackbarWithAction,
                    ),
                  ),
                  TestableWidget(
                    keyId: AppKeys.overlaysOpenDrawerBtn,
                    semanticLabel: 'Otwórz Boczne Menu (Drawer)',
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.menu),
                      label: const Text('Otwórz Boczne Menu (Drawer)'),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ),
                ],
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
