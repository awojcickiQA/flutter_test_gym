# Flutter Test Gym - Appium Automated Testing Framework

Profesjonalny framework testów automatycznych End-to-End (E2E) dla aplikacji **Flutter Test Gym**, zrealizowany w języku **Python**, z wykorzystaniem wzorca **Page Object Model (POM)**, bibliotek **Appium Python Client**, **Pytest** oraz **pytest-html**.

---

## 🏗️ Architektura Frameworka

```
appium_python/
├── .venv/                   # Środowisko wirtualne Python
├── conftest.py              # Konfiguracja Appium Driver (Android UiAutomator2 / iOS XCUITest)
├── pytest.ini               # Konfiguracja markerów testowych i raportowania
├── requirements.txt         # Zależności Python (Appium, pytest, selenium, etc.)
├── run_tests.sh             # Skrypt CLI do uruchamiania testów z raportem HTML
├── pages/                   # Page Object Model (POM)
│   ├── __init__.py          # Zbiorczy eksport Page Objects
│   ├── base_page.py         # Klasa bazowa z obsługą W3C Gestures (swipe, drag&drop, double-tap)
│   ├── home_page.py         # Ekran główny (Hub modułów, motyw, inspektor)
│   ├── forms_page.py        # Moduł 1: Formularze, maskowanie, debounce, kontrolki
│   ├── gestures_page.py     # Moduł 2: Gesty W3C, liczniki, drag-and-drop, canvas
│   ├── lists_page.py        # Moduł 3: Listy, wyszukiwanie, empty state, infinite scroll
│   ├── async_arena_page.py  # Moduł 4: Asynchroniczność, flakiness retry, toast, animacja
│   ├── overlays_page.py     # Moduł 5: Dialogi alert/confirm/prompt, bottom sheet, drawer
│   ├── shop_login_page.py   # Moduł 6: Logowanie do sklepu (walidacja błędów, quick-fill)
│   ├── shop_catalog_page.py # Moduł 6: Katalog produktów, filtry, koszyk badge
│   ├── shop_cart_page.py    # Moduł 6: Koszyk, ilości, kupon rabatowy DISCOUNT10
│   ├── shop_checkout_page.py# Moduł 6: Kasa (Stepper wielokrokowy: adres, kurier, BLIK)
│   ├── shop_order_success_page.py # Moduł 6: Potwierdzenie zamówienia (ORD-XXXXX)
│   ├── device_page.py       # Moduł 7: Integracje ze sprzętem (kamera, lokalizacja, biometria, offline)
│   ├── accessibility_page.py# Moduł 8: Dostępność, etykiety semantyczne, tryb RTL
│   └── test_inspector_page.py # Narzędzie wbudowane Test Inspector
└── tests/                   # Zestawy testów automatycznych Pytest
    ├── test_home_navigation.py  # Testy nawigacji głównej i motywu
    ├── test_forms.py            # Testy formularzy i walidacji
    ├── test_gestures.py         # Testy gestów W3C (tap, double tap, drag & drop)
    ├── test_lists.py            # Testy wyszukiwania i przewijania list
    ├── test_async_arena.py      # Testy operacji asynchronicznych i odporności na niestabilność
    ├── test_overlays.py         # Testy okien dialogowych i powiadomień
    ├── test_shop_e2e.py         # Pełny scenariusz E2E procesu zakupowego
    ├── test_device.py           # Testy symulacji sprzętowych i trybu offline
    ├── test_accessibility.py    # Testy kierunku tekstu RTL i dostępności
    └── test_inspector.py        # Testy wbudowanego narzędzia Test Inspector
```

---

## 🎯 Kluczowe Założenia Techniczne

1. **Lokalizatory we Flutterze:**
   Flutter domyślnie izoluje widżety przed natywną warstwą UI Automator / XCUITest. Aby elementy były widoczne dla `AppiumBy.ACCESSIBILITY_ID`, aplikacja wykorzystuje dedykowany widżet `TestableWidget`, który rejestruje semantyczne identyfikatory (`Semantics(identifier: AppKeys.xyz)`).
   
2. **Centralny Rejestr Kluczy:**
   Wszystkie selektory testowe odwołują się do stałych zdefiniowanych w `lib/core/constants/app_keys.dart`.

3. **Gesty W3C Actions:**
   Klasa `BasePage` implementuje standard W3C Actions API dla precyzyjnych gestów:
   - `double_tap(id)` – wielokrotne puknięcie palcem,
   - `long_press(id, duration_sec)` – przytrzymanie elementu,
   - `drag_and_drop(source_id, target_id)` – przeciągnięcie i upuszczenie,
   - `swipe_up()` / `swipe_down()` / `scroll_to_element(id)` – płynne przewijanie list.

4. **Multi-Platform:**
   `conftest.py` wspiera zarówno Androida (`UiAutomator2`), jak i iOS (`XCUITest`) z automatycznym zapisywaniem zrzutów ekranu w przypadku niepowodzenia testu.

---

## 🚀 Uruchamianie Testów

### 1. Wymagania wstępne
Upewnij się, że serwer Appium jest uruchomiony:
```bash
appium
```

### 2. Uruchomienie skryptem `run_tests.sh`
W katalogu `appium_python/`:

```bash
# Uruchomienie wszystkich testów na emulatorze Android:
./run_tests.sh --platform android

# Uruchomienie wszystkich testów na symulatorze iOS:
./run_tests.sh --platform ios

# Uruchomienie tylko testów dymnych (Smoke tests):
./run_tests.sh --marker smoke

# Uruchomienie testów sklepu E2E:
./run_tests.sh --marker shop

# Uruchomienie testów formularzy:
./run_tests.sh --marker forms
```

### 3. Uruchomienie bezpośrednio przez pytest
```bash
source .venv/bin/activate

# Android
pytest --platform android -m smoke --html=reports/smoke_report.html

# iOS
pytest --platform ios -m shop --html=reports/shop_report.html
```

---

## 🏷️ Dostępne Markery Testowe (`pytest.ini`)

- `@pytest.mark.smoke` – Kluczowe testy dymne
- `@pytest.mark.navigation` – Nawigacja i routing
- `@pytest.mark.forms` – Formularze, walidacja pól, maskowanie, debounce
- `@pytest.mark.gestures` – Gesty W3C (tap, double-tap, long-press, drag & drop)
- `@pytest.mark.lists` – Listy, filtrowanie, infinite scrolling
- `@pytest.mark.async_arena` – Asynchroniczność, flakiness retry, toasty
- `@pytest.mark.overlays` – Dialogi alert/confirm/prompt, bottom sheet, drawer
- `@pytest.mark.shop` – Pełny proces zakupowy E-commerce E2E
- `@pytest.mark.device` – Integracje systemowe i tryb offline
- `@pytest.mark.accessibility` – Dostępność (a11y) i RTL
- `@pytest.mark.inspector` – Wbudowany panel Test Inspector
