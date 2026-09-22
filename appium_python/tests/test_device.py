import pytest
from pages.home_page import HomePage
from pages.device_page import DevicePage

@pytest.fixture(autouse=True)
def open_device_screen(driver):
    home_page = HomePage(driver)
    home_page.open_device_module()
    device_page = DevicePage(driver)
    assert device_page.is_loaded()
    yield device_page

@pytest.mark.device
@pytest.mark.smoke
def test_device_permissions_and_features_mock(driver):
    """Weryfikacja symulacji uprawnień systemowych (Lokalizacja, Kamera, Biometria)."""
    device_page = DevicePage(driver)
    
    # Lokalizacja
    device_page.request_location()
    loc_status = device_page.get_location_status()
    assert len(loc_status) > 0

    # Kamera
    device_page.request_camera()
    cam_status = device_page.get_camera_status()
    assert len(cam_status) > 0

    # Biometria
    device_page.request_biometrics()
    bio_status = device_page.get_biometrics_status()
    assert len(bio_status) > 0

@pytest.mark.device
def test_device_mock_notification(driver):
    """Weryfikacja wywołania lokalnego powiadomienia push."""
    device_page = DevicePage(driver)
    device_page.trigger_notification()
    assert device_page.is_notification_banner_displayed(), "Baner powiadomienia push nie pojawił się!"

@pytest.mark.device
def test_device_offline_mode_toggle(driver):
    """Weryfikacja przełączenia aplikacji w stan offline."""
    device_page = DevicePage(driver)
    device_page.toggle_offline_mode()
    assert device_page.is_offline_banner_displayed(), "Ostrzeżenie o braku połączenia nie pojawiło się!"
