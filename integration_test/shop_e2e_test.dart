import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test_gym/main.dart';
import 'package:flutter_test_gym/core/constants/app_keys.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End (E2E) Przepływ Zakupowy w Sklepie', () {
    testWidgets('Pełna ścieżka: Logowanie -> Katalog -> Koszyk -> Kod Rabatowy -> Kasa -> Zamówienie', (WidgetTester tester) async {
      // 1. Uruchom całą aplikację
      await tester.pumpWidget(const FlutterTestGymApp());
      await tester.pumpAndSettle();

      // 2. Kliknij moduł sklepu na ekranie głównym
      final shopTileFinder = find.byKey(const Key(AppKeys.navModuleShop));
      await tester.tap(shopTileFinder);
      await tester.pumpAndSettle();

      // 3. Ekran Logowania: użyj autouzupełnienia
      final quickFillBtn = find.byKey(const Key(AppKeys.shopLoginQuickFillBtn));
      expect(quickFillBtn, findsOneWidget);
      await tester.tap(quickFillBtn);
      await tester.pump();

      final loginSubmitBtn = find.byKey(const Key(AppKeys.shopLoginSubmitBtn));
      await tester.tap(loginSubmitBtn);
      await tester.pumpAndSettle();

      // 4. Ekran Katalogu: zweryfikuj czy jesteśmy w katalogu
      expect(find.byKey(const Key(AppKeys.shopCatalogScreen)), findsOneWidget);

      // Dodaj pierwszy produkt do koszyka
      final addBtn = find.byKey(const Key('shop_product_add_btn_prod_1'));
      expect(addBtn, findsOneWidget);
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      // Przejdź do koszyka
      final cartBtn = find.byKey(const Key(AppKeys.shopCatalogCartBtn));
      await tester.tap(cartBtn);
      await tester.pumpAndSettle();

      // 5. Ekran Koszyka: wpisz kupon rabatowy
      expect(find.byKey(const Key(AppKeys.shopCartScreen)), findsOneWidget);
      final couponInput = find.byKey(const Key(AppKeys.shopCartCouponInput));
      await tester.enterText(couponInput, 'DISCOUNT10');

      final applyCouponBtn = find.byKey(const Key(AppKeys.shopCartCouponApplyBtn));
      await tester.tap(applyCouponBtn);
      await tester.pumpAndSettle();

      // Weryfikacja naliczonego rabatu
      expect(find.byKey(const Key(AppKeys.shopCartDiscountText)), findsOneWidget);

      // Przejdź do kasy
      final checkoutBtn = find.byKey(const Key(AppKeys.shopCartCheckoutBtn));
      await tester.tap(checkoutBtn);
      await tester.pumpAndSettle();

      // 6. Ekran Kasy (Stepper): Krok 1 - Dane adresowe
      expect(find.byKey(const Key(AppKeys.shopCheckoutScreen)), findsOneWidget);
      await tester.enterText(find.byKey(const Key(AppKeys.shopCheckoutNameInput)), 'Jan Testowy');
      await tester.enterText(find.byKey(const Key(AppKeys.shopCheckoutStreetInput)), 'ul. Zautomatyzowana 42');
      await tester.enterText(find.byKey(const Key(AppKeys.shopCheckoutZipInput)), '00-950');
      await tester.enterText(find.byKey(const Key(AppKeys.shopCheckoutCityInput)), 'Warszawa');

      // Przejdź do Kroku 2: Dostawa
      await tester.tap(find.byKey(const Key(AppKeys.shopCheckoutNextBtn)));
      await tester.pumpAndSettle();

      // Przejdź do Kroku 3: Płatność
      await tester.tap(find.byKey(const Key(AppKeys.shopCheckoutNextBtn)));
      await tester.pumpAndSettle();

      // Finalizuj zamówienie
      final placeOrderBtn = find.byKey(const Key(AppKeys.shopCheckoutPlaceOrderBtn));
      await tester.tap(placeOrderBtn);
      await tester.pumpAndSettle();

      // 7. Ekran Sukcesu: Asercja numeru zamówienia
      expect(find.byKey(const Key(AppKeys.shopOrderSuccessScreen)), findsOneWidget);
      final orderIdFinder = find.byKey(const Key(AppKeys.shopOrderIdText));
      expect(orderIdFinder, findsOneWidget);

      final Text orderIdWidget = tester.widget(orderIdFinder);
      final orderIdText = orderIdWidget.data ?? '';
      expect(RegExp(r'^ORD-\d+$').hasMatch(orderIdText), isTrue);
    });
  });
}
