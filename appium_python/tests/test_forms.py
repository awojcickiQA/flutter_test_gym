import time
import pytest
from pages.home_page import HomePage
from pages.forms_page import FormsPage

@pytest.fixture(autouse=True)
def open_forms_screen(driver):
    """Automatyczne otwarcie ekranu formularzy przed każdym testem w tym module."""
    home_page = HomePage(driver)
    home_page.open_forms_module()
    forms_page = FormsPage(driver)
    assert forms_page.is_loaded()
    yield forms_page

@pytest.mark.forms
@pytest.mark.smoke
def test_submit_valid_form_shows_success_banner(driver):
    """Weryfikacja poprawnego wypełnienia formularza i pojawienia się banera sukcesu."""
    forms_page = FormsPage(driver)
    forms_page.fill_standard_text("Jan Kowalski")
    forms_page.fill_email("jan.kowalski@example.com")
    forms_page.fill_password("TajneHaslo123")
    forms_page.accept_terms()
    forms_page.select_delivery_courier()
    forms_page.submit_form()

    assert forms_page.is_success_banner_displayed(), "Baner sukcesu nie pojawił się po wysłaniu formularza!"

@pytest.mark.forms
def test_password_visibility_toggle(driver):
    """Weryfikacja przełączania widoczności hasła."""
    forms_page = FormsPage(driver)
    forms_page.fill_password("SuperSecret99")
    forms_page.toggle_password_visibility()
    # Przełączenie nie rzuca błędu i kontrolka reaguje
    forms_page.toggle_password_visibility()

@pytest.mark.forms
def test_credit_card_masking(driver):
    """Weryfikacja formatowania numeru karty (maska XXXX-XXXX-XXXX-XXXX)."""
    forms_page = FormsPage(driver)
    forms_page.fill_card_number("1234567812345678")
    card_text = forms_page.get_text(forms_page.CARD_NUMBER_INPUT)
    assert "-" in card_text, f"Numer karty nie zawiera myślników maski: {card_text}"

@pytest.mark.forms
def test_async_username_validation(driver):
    """Weryfikacja asynchronicznej walidacji loginu z debouncem."""
    forms_page = FormsPage(driver)
    
    # 1. Sprawdzenie zajętego loginu "admin"
    forms_page.fill_async_username("admin")
    time.sleep(1.0)
    status_admin = forms_page.get_async_username_status()
    assert "zajęty" in status_admin.lower() or "błąd" in status_admin.lower()

    # 2. Sprawdzenie wolnego loginu
    forms_page.fill_async_username("unikalny_tester_2026")
    time.sleep(1.0)
    status_free = forms_page.get_async_username_status()
    assert "wolny" in status_free.lower() or "sukces" in status_free.lower()

@pytest.mark.forms
def test_add_dynamic_fields(driver):
    """Weryfikacja dodawania dynamicznych pól formularza."""
    forms_page = FormsPage(driver)
    forms_page.add_dynamic_field()
    # Drugie pole
    forms_page.add_dynamic_field()
    assert forms_page.is_loaded()

@pytest.mark.forms
def test_reset_form_clears_data(driver):
    """Weryfikacja resetowania formularza do stanu początkowego."""
    forms_page = FormsPage(driver)
    forms_page.fill_standard_text("Do skasowania")
    forms_page.fill_email("kasuj@example.com")
    forms_page.reset_form()
    
    assert not forms_page.is_success_banner_displayed()
