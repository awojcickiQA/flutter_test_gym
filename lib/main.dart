import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/forms/forms_screen.dart';
import 'features/gestures/gestures_screen.dart';
import 'features/lists/lists_screen.dart';
import 'features/async_arena/async_arena_screen.dart';
import 'features/overlays/overlays_screen.dart';
import 'features/shop/screens/shop_login_screen.dart';
import 'features/shop/screens/shop_catalog_screen.dart';
import 'features/shop/screens/shop_cart_screen.dart';
import 'features/shop/screens/shop_checkout_screen.dart';
import 'features/shop/screens/shop_order_success_screen.dart';
import 'features/device/device_screen.dart';
import 'features/accessibility/accessibility_screen.dart';

void main() {
  runApp(const FlutterTestGymApp());
}

class FlutterTestGymApp extends StatefulWidget {
  const FlutterTestGymApp({super.key});

  @override
  State<FlutterTestGymApp> createState() => _FlutterTestGymAppState();
}

class _FlutterTestGymAppState extends State<FlutterTestGymApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Gym',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => HomeScreen(
              onToggleTheme: _toggleTheme,
              currentThemeMode: _themeMode,
            ),
        AppRoutes.forms: (context) => const FormsScreen(),
        AppRoutes.gestures: (context) => const GesturesScreen(),
        AppRoutes.lists: (context) => const ListsScreen(),
        AppRoutes.asyncArena: (context) => const AsyncArenaScreen(),
        AppRoutes.overlays: (context) => const OverlaysScreen(),
        AppRoutes.shopLogin: (context) => const ShopLoginScreen(),
        AppRoutes.shopCatalog: (context) => const ShopCatalogScreen(),
        AppRoutes.shopCart: (context) => const ShopCartScreen(),
        AppRoutes.shopCheckout: (context) => const ShopCheckoutScreen(),
        AppRoutes.shopSuccess: (context) => const ShopOrderSuccessScreen(),
        AppRoutes.device: (context) => const DeviceScreen(),
        AppRoutes.accessibility: (context) => const AccessibilityScreen(),
      },
    );
  }
}
