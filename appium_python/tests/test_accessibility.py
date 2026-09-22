import pytest
from pages.home_page import HomePage
from pages.accessibility_page import AccessibilityPage

@pytest.fixture(autouse=True)
def open_a11y_screen(driver):
    home_page = HomePage(driver)
    home_page.open_accessibility_module()
    a11y_page = AccessibilityPage(driver)
    assert a11y_page.is_loaded()
    yield a11y_page

@pytest.mark.accessibility
@pytest.mark.smoke
def test_toggle_text_direction_rtl(driver):
    """Weryfikacja przełączania kierunku tekstu (LTR <-> RTL) i wsparcia dla języków arabskich/hebrajskich."""
    a11y_page = AccessibilityPage(driver)
    initial_dir = a11y_page.get_direction_text()

    a11y_page.toggle_rtl_ltr()
    new_dir = a11y_page.get_direction_text()

    assert initial_dir != new_dir, "Kierunek tekstu nie zmienił się po przełączeniu!"

@pytest.mark.accessibility
def test_high_contrast_mode_toggle(driver):
    """Weryfikacja trybu wysokiego kontrastu."""
    a11y_page = AccessibilityPage(driver)
    a11y_page.toggle_high_contrast()
    assert a11y_page.is_loaded()

@pytest.mark.accessibility
def test_semantics_card_accessibility(driver):
    """Weryfikacja dostępności karty ze specjalnymi etykietami semantycznymi dla czytników ekranu."""
    a11y_page = AccessibilityPage(driver)
    assert a11y_page.is_semantics_card_accessible(), "Karta semantyczna nie jest widoczna dla drivera ułatwień dostępu!"
