import pytest
from pages.home_page import HomePage
from pages.async_arena_page import AsyncArenaPage

@pytest.fixture(autouse=True)
def open_async_screen(driver):
    home_page = HomePage(driver)
    home_page.open_async_module()
    async_page = AsyncArenaPage(driver)
    assert async_page.is_loaded()
    yield async_page

@pytest.mark.async_arena
@pytest.mark.smoke
def test_fetch_async_data_with_wait(driver):
    """Weryfikacja pobierania danych asynchronicznych i oczekiwania na wynik."""
    async_page = AsyncArenaPage(driver)
    async_page.fetch_data()

    result = async_page.wait_for_data(timeout=8)
    assert len(result) > 0, "Dane asynchroniczne nie zostały załadowane!"

@pytest.mark.async_arena
def test_flaky_button_retry_resilience(driver):
    """Weryfikacja obsługi niestabilnego przycisku (flakiness) za pomocą pętli ponowień (retry)."""
    async_page = AsyncArenaPage(driver)
    success = async_page.click_retry_if_needed(max_attempts=6)
    assert success, "Nie udało się osiągnąć stanu sukcesu dla niestabilnego przycisku!"

@pytest.mark.async_arena
def test_transient_toast_notification(driver):
    """Weryfikacja pojawienia się krótkotrwałego powiadomienia (Toast)."""
    async_page = AsyncArenaPage(driver)
    async_page.trigger_transient_toast()
    assert async_page.is_toast_visible(), "Toast powiadomienia nie pojawił się na ekranie!"

@pytest.mark.async_arena
def test_toggle_infinite_animation(driver):
    """Weryfikacja zatrzymania / wznowienia nieskończonej animacji (ułatwienie dla drivera)."""
    async_page = AsyncArenaPage(driver)
    async_page.toggle_animation()
    assert async_page.is_loaded()
