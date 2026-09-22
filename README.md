# 🏋️‍♂️ Flutter Test Gym (Automation Sandbox)

Kompleksowa aplikacja demonstracyjna i poligon doświadczalny we **Flutterze** zaprojektowana specjalnie do nauki i doskonalenia **automatyzacji testów aplikacji mobilnych**.

Zawiera pełne spektrum komponentów UI, zaawansowanych gestów, pułapek timingowych i asynchronicznych oraz kompletny proces biznesowy E-Commerce.

---

## 🎯 Dla kogo jest ta aplikacja?
- **Inżynierów QA Automation & SDET** przechodzących z testów webowych (Selenium, Playwright, Cypress) do testów mobilnych.
- **Testerów manualnych** uczących się pisania skryptów automatycznych.
- **Flutter Developerów** chcących opanować testy widżetów (`WidgetTester`) oraz testy integracyjne (`integration_test`).
- Każdego, kto chce przećwiczyć narzędzia takie jak: **Patrol**, **Maestro**, **Appium** lub natywne testy Fluttera.

---

## 🧭 Mapa Modułów i Scenariuszy Treningowych

| # | Moduł | Trasa | Wyzwania Automatyzacji |
|---|---|---|---|
| **1** | **Formularze & Kontrolki** | `/forms` | Maski kart (XXXX-XXXX), podgląd hasła, asynchroniczny debounce loginu, checkboxy trójstanowe, suwaki, pickery daty/czasu, dynamiczne wiersze. |
| **2** | **Gesty & Dotyk** | `/gestures` | Single tap, Double tap, Long press, `ReorderableListView` (zmiana kolejności), `Draggable` + `DragTarget`, Swipe to dismiss, Pinch-to-zoom, podpis canvas. |
| **3** | **Listy & Wirtualizacja** | `/lists` | Leniwe ładowanie (500 elementów), `scrollUntilVisible`, dociąganie paginacji, Pull-to-refresh (`RefreshIndicator`), wyszukiwarka z filtrowaniem. |
| **4** | **Asynchroniczność & Flakiness** | `/async` | **Pułapka `pumpAndSettle`** (nieskończona animacja zawieszająca testy), konfigurowalne opóźnienia sieciowe (0s, 1s, 3s, 5s), Flaky button z błędem 500 i mechanizmem retry, auto-znikający baner (2s TTL). |
| **5** | **Dialogi, Modale & Nakładki** | `/overlays` | Prosty alert, dialog potwierdzenia zwracający wynik, prompt z wpisywaniem hasła, Modal Bottom Sheet, SnackBar z akcją "Cofnij", boczny Drawer. |
| **6** | **E2E: Sklep Internetowy** | `/shop/login` | Kompletny przepływ biznesowy: Logowanie $\to$ Katalog $\to$ Filtry $\to$ Koszyk $\to$ Kupon `DISCOUNT10` $\to$ 3-krokowy Stepper Kasy $\to$ Identyfikator zamówienia z asercją regex. |
| **7** | **Integracje Systemowe** | `/device` | Uprawnienia systemowe (Lokalizacja, Aparat) dla Patrola, mock biometrii (FaceID), powiadomienia lokalne, symulacja WebView (hybrydowe konteksty), tryb offline. |
| **8** | **Dostępność & Edge Cases** | `/accessibility` | Przełączanie kierunku RTL (Arabski), audyt drzewa `Semantics`, **Wyzwanie Brakujące Klucze** (lokalizacja po relacji przodek-potomek bez `Key`). |

---

## 🔍 Wbudowany "Test Inspector" (Tryb Podglądu Selektorów)

W prawym dolnym rogu każdego ekranu znajduje się pływający żółty przycisk z ikoną 🐛 (**Test Inspector**).
Po jego kliknięciu:
1. Wyświetla się lista wszystkich kluczy zarejestrowanych dla aktualnego widoku.
2. Możesz przełączać zakładki frameworków (**Flutter Test**, **Patrol**, **Maestro**, **Appium / Pytest**), aby natychmiast zobaczyć gotowy kod selektora do skopiowania do swojego testu!

---

## 📐 Standaryzacja Selektorów (Locators Architecture)

Wszystkie klucze są zdefiniowane centralnie w [lib/core/constants/app_keys.dart](file:///Users/arturwojcicki/Flutter%20test%20app/lib/core/constants/app_keys.dart).

Każdy kluczowy element interfejsu posiada zarówno identyfikator widżetowy Fluttera, jak i wpis w drzewie dostępności:

| Narzędzie | Typ Selektora | Przykład Kodu |
|---|---|---|
| **flutter_test / integration_test** | `Key` | `find.byKey(const Key(AppKeys.formsEmailInput))` |
| **Patrol** | Semantics ID / Key | `$(#forms_email_input)` lub `$('/forms_email_input')` |
| **Maestro** | Accessibility ID | `- inputText: id: "forms_email_input"` |
| **Appium (Python)** | Accessibility ID | `driver.find_element(AppiumBy.ACCESSIBILITY_ID, "forms_email_input")` |

---

## 🚀 Jak Uruchomić Aplikację i Testy

### 1. Uruchomienie Aplikacji
```bash
# Pobranie zależności
flutter pub get

# Uruchomienie na podłączonym emulatorze/urządzeniu lub w przeglądarce Chrome
flutter run
```

### 2. Uruchomienie Testów Widżetów (`flutter_test`)
```bash
flutter test test/widget_tests/forms_test.dart
flutter test test/widget_tests/async_arena_test.dart
```

### 3. Uruchomienie Testów Integracyjnych E2E w Darcie
```bash
flutter test integration_test/shop_e2e_test.dart
```

### 4. Uruchomienie Testów Maestro
Zainstaluj Maestro ([maestro.mobile.dev](https://maestro.mobile.dev)):
```bash
maestro test maestro/login_and_checkout.yaml
maestro test maestro/gestures_and_lists.yaml
```

### 5. Uruchomienie Testów Pytest + Appium
```bash
cd appium_python
pip install -r requirements.txt
pytest -v
```

---

## 📂 Struktura Projektu
```
├── lib/
│   ├── core/
│   │   ├── constants/           # AppKeys (rejestr selektorów), AppRoutes
│   │   ├── theme/               # Material 3 Light/Dark Themes
│   │   └── widgets/             # TestableWidget (Key + Semantics wrapper)
│   ├── dev_tools/               # TestInspectorOverlay (pływający inspektor selektorów)
│   ├── features/
│   │   ├── home/                # Ekran główny z listą poligonów
│   │   ├── forms/               # Moduł 1: Formularze i walidacje
│   │   ├── gestures/            # Moduł 2: Gesty, Drag&Drop, Swipe
│   │   ├── lists/               # Moduł 3: Listy, Infinite scroll, wyszukiwarka
│   │   ├── async_arena/         # Moduł 4: Timingi, pumpAndSettle, retry
│   │   ├── overlays/            # Moduł 5: Dialogi, Bottom Sheets, Drawer
│   │   ├── shop/                # Moduł 6: Sklep E2E (Login, Catalog, Cart, Checkout, Success)
│   │   ├── device/              # Moduł 7: Uprawnienia, Biometria, Offline
│   │   └── accessibility/       # Moduł 8: RTL, Semantics, Missing Keys
│   └── main.dart                # Główny routing i start aplikacji
├── test/                        # Testy widżetów (flutter_test)
├── integration_test/            # Testy integracyjne E2E (Dart)
├── maestro/                     # Deklaratywne scenariusze YAML Maestro
└── appium_python/               # Testy automatyczne w Pythonie (pytest + Appium)
```
