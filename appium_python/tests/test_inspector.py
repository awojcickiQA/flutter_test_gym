import pytest
from pages.home_page import HomePage
from pages.forms_page import FormsPage
from pages.test_inspector_page import TestInspectorPage

@pytest.mark.inspector
def test_inspector_shows_keys_for_current_screen(driver):
    """
    Weryfikacja wbudowanego narzędzia Test Inspector:
    1. Nawigacja do modułu formularzy
    2. Otwarcie panelu inspektora
    3. Sprawdzenie, czy aktywna ścieżka to '/forms'
    4. Zamknięcie panelu
    """
    home_page = HomePage(driver)
    home_page.open_forms_module()

    forms_page = FormsPage(driver)
    assert forms_page.is_loaded()

    # Otwarcie inspektora
    home_page.toggle_inspector()
    inspector = TestInspectorPage(driver)
    assert inspector.is_open(), "Panel inspektora nie otworzył się!"

    route_name = inspector.get_active_route_name()
    assert "/forms" in route_name, f"Oczekiwano trasy /forms, otrzymano: {route_name}"

    inspector.close()
    assert not inspector.is_open(), "Panel inspektora nie zamknął się po kliknięciu przycisku!"
