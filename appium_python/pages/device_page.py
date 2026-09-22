from .base_page import BasePage

class DevicePage(BasePage):
    """Page Object dla modułu Integracje Urządzenia (Device & System)."""
    DEVICE_SCREEN = "device_screen"
    REQ_LOCATION_BTN = "device_req_location_btn"
    LOCATION_STATUS = "device_location_status_text"
    REQ_CAMERA_BTN = "device_req_camera_btn"
    CAMERA_STATUS = "device_camera_status_text"
    REQ_BIOMETRICS_BTN = "device_req_biometrics_btn"
    BIOMETRICS_STATUS = "device_biometrics_status_text"
    MOCK_NOTIFICATION_BTN = "device_mock_notification_btn"
    NOTIFICATION_BANNER = "device_notification_banner"
    NETWORK_TOGGLE = "device_network_toggle"
    OFFLINE_BANNER = "device_offline_warning_banner"

    def is_loaded(self) -> bool:
        return (
            self.is_displayed(self.REQ_LOCATION_BTN, timeout=3) or
            self.is_displayed(self.NETWORK_TOGGLE, timeout=1) or
            self.is_displayed(self.DEVICE_SCREEN, timeout=1)
        )

    def request_location(self):
        from appium.webdriver.common.appiumby import AppiumBy
        from selenium.webdriver.support.wait import WebDriverWait
        from selenium.webdriver.support import expected_conditions as EC
        import time
        self.click(self.REQ_LOCATION_BTN)
        try:
            grant_btn = WebDriverWait(self.driver, 4).until(
                EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@text, 'Zezwól') or contains(@content-desc, 'Zezwól') or contains(@name, 'Zezwól') or contains(@label, 'Zezwól')]"))
            )
            grant_btn.click()
            time.sleep(0.5)
        except Exception:
            pass

    def get_location_status(self) -> str:
        return self.get_text(self.LOCATION_STATUS)

    def request_camera(self):
        from appium.webdriver.common.appiumby import AppiumBy
        from selenium.webdriver.support.wait import WebDriverWait
        from selenium.webdriver.support import expected_conditions as EC
        import time
        self.click(self.REQ_CAMERA_BTN)
        try:
            grant_btn = WebDriverWait(self.driver, 4).until(
                EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@text, 'Zezwól') or contains(@content-desc, 'Zezwól') or contains(@name, 'Zezwól') or contains(@label, 'Zezwól')]"))
            )
            grant_btn.click()
            time.sleep(0.5)
        except Exception:
            pass

    def get_camera_status(self) -> str:
        return self.get_text(self.CAMERA_STATUS)

    def request_biometrics(self):
        from appium.webdriver.common.appiumby import AppiumBy
        from selenium.webdriver.support.wait import WebDriverWait
        from selenium.webdriver.support import expected_conditions as EC
        import time
        self.click(self.REQ_BIOMETRICS_BTN)
        try:
            scan_btn = WebDriverWait(self.driver, 4).until(
                EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@text, 'skan') or contains(@content-desc, 'skan') or contains(@text, 'Symuluj') or contains(@name, 'skan') or contains(@label, 'skan') or contains(@name, 'Symuluj') or contains(@label, 'Symuluj')]"))
            )
            scan_btn.click()
            time.sleep(0.5)
        except Exception:
            pass

    def get_biometrics_status(self) -> str:
        return self.get_text(self.BIOMETRICS_STATUS)

    def trigger_notification(self):
        self.scroll_to_element(self.MOCK_NOTIFICATION_BTN)
        self.click(self.MOCK_NOTIFICATION_BTN)

    def is_notification_banner_displayed(self) -> bool:
        return self.is_displayed(self.NOTIFICATION_BANNER, timeout=3)

    def toggle_offline_mode(self):
        self.scroll_to_element(self.NETWORK_TOGGLE)
        self.click(self.NETWORK_TOGGLE)

    def is_offline_banner_displayed(self) -> bool:
        if self.is_displayed(self.OFFLINE_BANNER, timeout=1):
            return True
        # Baner pojawia się na samej górze ekranu – przewijamy do góry
        self.swipe_down(percent=0.6)
        return self.is_displayed(self.OFFLINE_BANNER, timeout=3)
