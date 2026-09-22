import pytest
from pages.home_page import HomePage
from pages.overlays_page import OverlaysPage

@pytest.fixture(autouse=True)
def open_overlays_screen(driver):
    home_page = HomePage(driver)
    home_page.open_overlays_module()
    overlays_page = OverlaysPage(driver)
    assert overlays_page.is_loaded()
    yield overlays_page

@pytest.mark.overlays
@pytest.mark.smoke
def test_alert_dialog_lifecycle(driver):
    """Weryfikacja wywołania i zamknięcia okna dialogowego Alert."""
    overlays_page = OverlaysPage(driver)
    overlays_page.trigger_and_accept_alert()
    assert overlays_page.is_loaded()

@pytest.mark.overlays
def test_confirm_dialog_selection(driver):
    """Weryfikacja wyboru w oknie dialogowym Potwierdzenia (Tak / Nie)."""
    overlays_page = OverlaysPage(driver)
    
    # 1. Wybór: Tak
    overlays_page.trigger_confirm_dialog(accept=True)
    res_yes = overlays_page.get_dialog_result()
    assert "tak" in res_yes.lower()

    # 2. Wybór: Nie
    overlays_page.trigger_confirm_dialog(accept=False)
    res_no = overlays_page.get_dialog_result()
    assert "nie" in res_no.lower()

@pytest.mark.overlays
def test_prompt_dialog_input(driver):
    """Weryfikacja wprowadzania tekstu w oknie Prompt Dialog."""
    overlays_page = OverlaysPage(driver)
    secret_value = "APPIUM_ROBOT_2026"
    overlays_page.trigger_prompt_dialog(secret_value)

    res_prompt = overlays_page.get_dialog_result()
    assert secret_value in res_prompt

@pytest.mark.overlays
def test_bottom_sheet_interaction(driver):
    """Weryfikacja wysuwania i zamykania Modal Bottom Sheet."""
    overlays_page = OverlaysPage(driver)
    overlays_page.open_and_close_bottom_sheet()
    assert overlays_page.is_loaded()

@pytest.mark.overlays
def test_navigation_drawer_open(driver):
    """Weryfikacja otwierania bocznego menu nawigacyjnego (Drawer)."""
    overlays_page = OverlaysPage(driver)
    overlays_page.open_drawer()
    assert overlays_page.is_drawer_open(), "Boczny drawer nie otworzył się!"
