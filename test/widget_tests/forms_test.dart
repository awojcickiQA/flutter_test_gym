import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_gym/core/constants/app_keys.dart';
import 'package:flutter_test_gym/features/forms/forms_screen.dart';

void main() {
  group('Moduł Formularzy - Testy Widżetów (Widget Tests)', () {
    testWidgets('Poprawne wypełnienie formularza i weryfikacja banera sukcesu', (WidgetTester tester) async {
      // 1. Zbuduj ekran formularza
      await tester.pumpWidget(const MaterialApp(home: FormsScreen()));
      await tester.pumpAndSettle();

      // 2. Wprowadź tekst do standardowego inputu
      final standardInputFinder = find.byKey(const Key(AppKeys.formsStandardInput));
      expect(standardInputFinder, findsOneWidget);
      await tester.enterText(standardInputFinder, 'Przykładowy tekst testowy');

      // 3. Wprowadź poprawny e-mail
      final emailFinder = find.byKey(const Key(AppKeys.formsEmailInput));
      await tester.enterText(emailFinder, 'tester@example.com');

      // 4. Wprowadź hasło i zweryfikuj działanie przełącznika podglądu hasła
      final passwordFinder = find.byKey(const Key(AppKeys.formsPasswordInput));
      await tester.enterText(passwordFinder, 'BezpieczneHaslo123!');

      final togglePasswordBtn = find.byKey(const Key(AppKeys.formsPasswordToggleBtn));
      expect(togglePasswordBtn, findsOneWidget);
      await tester.tap(togglePasswordBtn);
      await tester.pump();

      // 5. Zaznacz regulamin (wymagany checkbox)
      final termsCheckbox = find.byKey(const Key(AppKeys.formsCheckboxTerms));
      await tester.ensureVisible(termsCheckbox);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();

      // 6. Kliknij przycisk Zatwierdź Formularz
      final submitBtn = find.byKey(const Key(AppKeys.formsSubmitBtn));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // 7. Asercja: Baner sukcesu powinien być widoczny
      final successBanner = find.byKey(const Key(AppKeys.formsSuccessBanner));
      expect(successBanner, findsOneWidget);
      expect(find.text('Formularz pomyślnie zatwierdzony!'), findsOneWidget);
    });

    testWidgets('Walidacja niepoprawnego adresu e-mail', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FormsScreen()));
      await tester.pumpAndSettle();

      // Wpisz błędny email
      await tester.enterText(find.byKey(const Key(AppKeys.formsEmailInput)), 'niepoprawny-email');
      
      // Kliknij regulamin i zatwierdź
      final termsCheckbox = find.byKey(const Key(AppKeys.formsCheckboxTerms));
      await tester.ensureVisible(termsCheckbox);
      await tester.tap(termsCheckbox);

      final submitBtn = find.byKey(const Key(AppKeys.formsSubmitBtn));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Asercja: Wyświetlono komunikat błędu walidacji
      expect(find.text('Wprowadź poprawny adres e-mail'), findsOneWidget);
      expect(find.byKey(const Key(AppKeys.formsSuccessBanner)), findsNothing);
    });
  });
}
