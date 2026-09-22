import pytest
from pages.home_page import HomePage
from pages.gestures_page import GesturesPage

@pytest.fixture(autouse=True)
def open_gestures_screen(driver):
    home_page = HomePage(driver)
    home_page.open_gestures_module()
    gestures_page = GesturesPage(driver)
    assert gestures_page.is_loaded()
    yield gestures_page

@pytest.mark.gestures
@pytest.mark.smoke
def test_single_tap_increments_counter(driver):
    """Weryfikacja zliczania pojedynczych kliknięć."""
    gestures_page = GesturesPage(driver)
    initial_count = gestures_page.get_single_tap_count()

    gestures_page.tap_single_area()
    new_count = gestures_page.get_single_tap_count()

    assert initial_count != new_count, "Licznik pojedynczych kliknięć nie zwiększył się!"

@pytest.mark.gestures
def test_double_tap_increments_counter(driver):
    """Weryfikacja podwójnego kliknięcia (double-tap)."""
    gestures_page = GesturesPage(driver)
    initial_count = gestures_page.get_double_tap_count()

    gestures_page.perform_double_tap()
    new_count = gestures_page.get_double_tap_count()

    assert initial_count != new_count, "Licznik podwójnych kliknięć nie zwiększył się!"

@pytest.mark.gestures
def test_long_press_triggers_feedback(driver):
    """Weryfikacja długiego naciśnięcia (long press)."""
    gestures_page = GesturesPage(driver)
    gestures_page.perform_long_press(duration_sec=1.5)

    feedback = gestures_page.get_long_press_feedback()
    assert len(feedback) > 0, "Komunikat feedbacku po long press nie pojawił się!"

@pytest.mark.gestures
def test_drag_and_drop_to_bin(driver):
    """Weryfikacja przeciągania elementu do kosza (drag and drop)."""
    gestures_page = GesturesPage(driver)
    initial_score = gestures_page.get_drag_score()

    gestures_page.perform_drag_and_drop()
    new_score = gestures_page.get_drag_score()

    assert initial_score != new_score, "Wynik przeciągania nie zmienił się po upuszczeniu do celu!"

@pytest.mark.gestures
def test_clear_canvas_signature(driver):
    """Weryfikacja czyszczenia obszaru rysowania podpisu."""
    gestures_page = GesturesPage(driver)
    gestures_page.clear_canvas()
    assert gestures_page.is_loaded()
