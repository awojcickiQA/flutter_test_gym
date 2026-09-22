import pytest
from pages.home_page import HomePage
from pages.forms_page import FormsPage
from pages.gestures_page import GesturesPage
from pages.lists_page import ListsPage
from pages.async_arena_page import AsyncArenaPage
from pages.overlays_page import OverlaysPage
from pages.shop_login_page import ShopLoginPage
from pages.device_page import DevicePage
from pages.accessibility_page import AccessibilityPage
from pages.test_inspector_page import TestInspectorPage

@pytest.mark.navigation
@pytest.mark.smoke
def test_home_screen_elements_loaded(driver):
    """Weryfikacja załadowania ekranu głównego i kafelków nawigacyjnych."""
    home_page = HomePage(driver)
    assert home_page.is_loaded(), "Ekran główny nie został załadowany!"

@pytest.mark.navigation
def test_navigate_to_forms_module(driver):
    """Nawigacja z ekranu głównego do modułu Formularze."""
    home_page = HomePage(driver)
    home_page.open_forms_module()

    forms_page = FormsPage(driver)
    assert forms_page.is_loaded(), "Ekran formularzy nie otworzył się!"

@pytest.mark.navigation
def test_navigate_to_gestures_module(driver):
    """Nawigacja do modułu Gesty."""
    home_page = HomePage(driver)
    home_page.open_gestures_module()

    gestures_page = GesturesPage(driver)
    assert gestures_page.is_loaded(), "Ekran gestów nie otworzył się!"

@pytest.mark.navigation
def test_navigate_to_shop_module(driver):
    """Nawigacja do modułu Sklepu E-commerce."""
    home_page = HomePage(driver)
    home_page.open_shop_module()

    shop_login_page = ShopLoginPage(driver)
    assert shop_login_page.is_loaded(), "Ekran logowania sklepu nie otworzył się!"

@pytest.mark.navigation
def test_toggle_theme_mode(driver):
    """Weryfikacja przełączania motywu jasnego/ciemnego."""
    home_page = HomePage(driver)
    home_page.toggle_theme()
    assert home_page.is_loaded()

@pytest.mark.navigation
@pytest.mark.inspector
def test_toggle_inspector_overlay(driver):
    """Weryfikacja otwierania i zamykania Test Inspector Overlay."""
    home_page = HomePage(driver)
    home_page.toggle_inspector()

    inspector = TestInspectorPage(driver)
    assert inspector.is_open(), "Panel inspektora nie otworzył się!"
    inspector.close()
    assert not inspector.is_open(), "Panel inspektora nie zamknął się!"
