import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_gym/core/constants/app_keys.dart';
import 'package:flutter_test_gym/features/async_arena/async_arena_screen.dart';

void main() {
  group('Asynchroniczność & Flakiness Arena - Widget Tests', () {
    testWidgets('Poprawna obsługa ekranu z nieskończoną animacją (Unikanie pumpAndSettle timeout)', (WidgetTester tester) async {
      // Budujemy ekran. Posiada on AnimationController.repeat(), który nigdy się nie zatrzymuje.
      await tester.pumpWidget(const MaterialApp(home: AsyncArenaScreen()));

      // WAŻNA LEKCJA DLA QA:
      // Gdybyśmy wywołali: await tester.pumpAndSettle();
      // Test zawiesiłby się i rzucił błąd timeoutu!
      // Zamiast tego wykonujemy kontrolowany pojedynczy krok:
      await tester.pump(const Duration(milliseconds: 100));

      // Weryfikacja obecności obracającego się widżetu
      expect(find.byKey(const Key(AppKeys.asyncInfiniteAnimationWidget)), findsOneWidget);

      // Zatrzymujemy animację przyciskiem
      final toggleAnimBtn = find.byKey(const Key(AppKeys.asyncAnimationToggleBtn));
      await tester.tap(toggleAnimBtn);
      await tester.pump();

      expect(find.text('Wznów animację'), findsOneWidget);
    });

    testWidgets('Testowanie symulowanego opóźnienia sieciowego z kontrolowanym pump(Duration)', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AsyncArenaScreen()));
      await tester.pump();

      // Wybieramy opóźnienie 1s
      final fetchBtn = find.byKey(const Key(AppKeys.asyncFetchDataBtn));
      await tester.tap(fetchBtn);
      await tester.pump(); // Inicjuje asynchroniczną akcję

      // Sprawdzamy czy spinner ładowania jest natychmiast widoczny
      expect(find.byKey(const Key(AppKeys.asyncLoadingSpinner)), findsOneWidget);

      // Przewijamy czas wirtualnego zegara Fluttera o 1 sekundę
      await tester.pump(const Duration(seconds: 1));

      // Asercja: Dane zostały załadowane i spinner zniknął
      expect(find.byKey(const Key(AppKeys.asyncResultText)), findsOneWidget);
      expect(find.byKey(const Key(AppKeys.asyncLoadingSpinner)), findsNothing);
    });
  });
}
