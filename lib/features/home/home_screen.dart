import 'package:flutter/material.dart';
import '../../core/constants/app_keys.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/testable_widget.dart';
import '../../dev_tools/test_inspector_overlay.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode currentThemeMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.navModuleForms,
      AppKeys.navModuleGestures,
      AppKeys.navModuleLists,
      AppKeys.navModuleAsync,
      AppKeys.navModuleOverlays,
      AppKeys.navModuleShop,
      AppKeys.navModuleDevice,
      AppKeys.navModuleAccessibility,
      AppKeys.toggleThemeBtn,
      AppKeys.toggleInspectorBtn,
    ];

    final modules = [
      _ModuleItem(
        keyId: AppKeys.navModuleForms,
        route: AppRoutes.forms,
        title: '1. Formularze & Kontrolki',
        subtitle: 'Pola tekstowe, maskowanie, walidacja asynchroniczna, checkboxy, slidery, pickery.',
        icon: Icons.edit_note,
        color: Colors.blue,
      ),
      _ModuleItem(
        keyId: AppKeys.navModuleGestures,
        route: AppRoutes.gestures,
        title: '2. Gesty & Interakcje',
        subtitle: 'Tap, Double-tap, Long press, Drag & Drop, Swipe-to-dismiss, Pinch-zoom, Canvas.',
        icon: Icons.touch_app,
        color: Colors.purple,
      ),
      _ModuleItem(
        keyId: AppKeys.navModuleLists,
        route: AppRoutes.lists,
        title: '3. Listy & Wirtualizacja',
        subtitle: 'Infinite scroll, lazy loading, scrollUntilVisible, pull-to-refresh, dynamiczne filtry.',
        icon: Icons.format_list_bulleted,
        color: Colors.teal,
      ),
      _ModuleItem(
        keyId: AppKeys.navModuleAsync,
        route: AppRoutes.asyncArena,
        title: '4. Asynchroniczność & Flakiness',
        subtitle: 'Pułapka pumpAndSettle, opóźnienia sieciowe, retry dla błędów 500, komunikaty z TTL.',
        icon: Icons.hourglass_top,
        color: Colors.orange,
      ),
      _ModuleItem(
        keyId: AppKeys.navModuleOverlays,
        route: AppRoutes.overlays,
        title: '5. Dialogi & Nakładki',
        subtitle: 'Alert, Confirm zwracający wynik, Prompt kodowy, Bottom Sheet, SnackBar, Drawer.',
        icon: Icons.picture_in_picture_alt,
        color: Colors.amber.shade900,
      ),
      _ModuleItem(
        keyId: AppKeys.navModuleShop,
        route: AppRoutes.shopLogin,
        title: '6. E2E: Sklep Internetowy',
        subtitle: 'Pełny proces: Logowanie -> Katalog -> Koszyk -> 3-krokowy Checkout -> Sukces.',
        icon: Icons.shopping_bag,
        color: Colors.green,
      ),
      _ModuleItem(
        keyId: AppKeys.navModuleDevice,
        route: AppRoutes.device,
        title: '7. Funkcje Natywne & Device',
        subtitle: 'Uprawnienia GPS/Aparat (Patrol), mock biometrii, powiadomienia, WebView.',
        icon: Icons.smartphone,
        color: Colors.redAccent,
      ),
      _ModuleItem(
        keyId: AppKeys.navModuleAccessibility,
        route: AppRoutes.accessibility,
        title: '8. Dostępność, RTL & Missing Keys',
        subtitle: 'Układ arabski RTL, audyt Semantics, zadanie wyszukiwania bez kluczy po relacjach.',
        icon: Icons.accessibility_new,
        color: Colors.deepPurple,
      ),
    ];

    return TestInspectorOverlay(
      currentRoute: '/',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.homeScreen),
        appBar: AppBar(
          title: const Text('Flutter Test Gym 🎯'),
          actions: [
            TestableWidget(
              keyId: AppKeys.toggleThemeBtn,
              semanticLabel: 'Przełącz motyw jasny/ciemny',
              child: IconButton(
                tooltip: 'Przełącz motyw jasny/ciemny',
                icon: Icon(currentThemeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                onPressed: onToggleTheme,
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nagłówek powitalny
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade600, Colors.deepPurple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Witaj na poligonie testowym!',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Aplikacja zaprojektowana specjalnie do nauki i treningu automatyzacji testów mobilnych (flutter_test, Patrol, Maestro, Appium / Pytest). '
                    'Wybierz moduł poniżej lub skorzystaj z żółtego przycisku w prawym dolnym rogu (Test Inspector), aby podejrzeć selektory.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Moduły i Wyzwania Testowe:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...modules.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: TestableWidget(
                  keyId: item.keyId,
                  semanticLabel: item.title,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.color.withOpacity(0.15),
                      child: Icon(item.icon, color: item.color),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.of(context).pushNamed(item.route);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ModuleItem {
  final String keyId;
  final String route;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  _ModuleItem({
    required this.keyId,
    required this.route,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
