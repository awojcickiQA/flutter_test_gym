import 'package:flutter/material.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/testable_widget.dart';
import '../../../dev_tools/test_inspector_overlay.dart';
import '../controllers/shop_state.dart';

class ShopOrderSuccessScreen extends StatelessWidget {
  const ShopOrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = ShopState.instance.lastOrderId ?? 'ORD-99999';

    final availableKeys = [
      AppKeys.shopOrderIdText,
      AppKeys.shopOrderSuccessHomeBtn,
    ];

    return TestInspectorOverlay(
      currentRoute: '/shop/success',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.shopOrderSuccessScreen),
        appBar: AppBar(
          title: const Text('Podsumowanie Zamówienia'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 80, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  'Dziękujemy za złożenie zamówienia!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Twoje zamówienie zostało pomyślnie zarejestrowane w systemie testowym.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.indigo),
                  ),
                  child: Column(
                    children: [
                      const Text('Numer zamówienia (do asercji regex):', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      TestableWidget(
                        keyId: AppKeys.shopOrderIdText,
                        semanticLabel: orderId,
                        child: SelectableText(
                          orderId,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                TestableWidget(
                  keyId: AppKeys.shopOrderSuccessHomeBtn,
                  semanticLabel: 'Wróć do Katalogu Sklepu',
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.home),
                    label: const Text('Wróć do Katalogu Sklepu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.shopCatalog, (route) => route.isFirst);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
