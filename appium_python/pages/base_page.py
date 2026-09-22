import time
from typing import List, Optional
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.actions.action_builder import ActionBuilder
from selenium.webdriver.common.actions.pointer_input import PointerInput
from selenium.webdriver.common.actions import interaction
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException, StaleElementReferenceException

class BasePage:
    """
    Klasa bazowa dla Page Object Model.
    Wspiera zarówno Android (UiAutomator2: resource-id/content-desc) jak i iOS (XCUITest: name/accessibility-id)
    oraz standard gestów W3C Actions API.
    """
    def __init__(self, driver, default_timeout: int = 10):
        self.driver = driver
        self.timeout = default_timeout
        self.wait = WebDriverWait(driver, default_timeout)

    @property
    def is_ios(self) -> bool:
        return self.driver.capabilities.get('platformName', '').lower() == 'ios'

    def _build_locator(self, accessibility_id: str):
        """
        Uniwersalny lokator dopasowujący identyfikator do natywnej reprezentacji
        Flutter Semantics (resource-id na Androidzie oraz name/label na iOS).
        """
        return (
            AppiumBy.XPATH,
            f"//*[@resource-id='{accessibility_id}' or "
            f"@resource-id='com.example.flutter_test_gym:id/{accessibility_id}' or "
            f"@content-desc='{accessibility_id}' or "
            f"@name='{accessibility_id}' or "
            f"@label='{accessibility_id}']"
        )

    def find_by_accessibility_id(self, accessibility_id: str, timeout: Optional[int] = None):
        """Wyszukuje pojedynczy element po identyfikatorze testowym z jawnym oczekiwaniem."""
        wait = WebDriverWait(self.driver, timeout or self.timeout)
        by, value = self._build_locator(accessibility_id)
        return wait.until(
            EC.presence_of_element_located((by, value))
        )

    def find_elements_by_accessibility_id(self, accessibility_id: str) -> List:
        """Wyszukuje listę elementów po identyfikatorze testowym."""
        by, value = self._build_locator(accessibility_id)
        return self.driver.find_elements(by, value)

    def click(self, accessibility_id: str, timeout: Optional[int] = None):
        """Klika element po identyfikatorze."""
        elem = self.find_by_accessibility_id(accessibility_id, timeout)
        time.sleep(0.3)
        elem.click()

    def _get_input_element(self, container_elem):
        """Jeśli kontener z Semantics zawiera właściwe pole wprowadzania (EditText/TextField), zwraca je."""
        for locator in [
            (AppiumBy.CLASS_NAME, "android.widget.EditText"),
            (AppiumBy.XPATH, ".//android.widget.EditText"),
            (AppiumBy.XPATH, ".//XCUIElementTypeTextField | .//XCUIElementTypeSecureTextField"),
        ]:
            try:
                children = container_elem.find_elements(*locator)
                if children:
                    return children[0]
            except Exception:
                pass
        return container_elem

    def hide_keyboard(self):
        """Chowa klawiaturę ekranową, jeśli jest otwarta."""
        platform = self.driver.capabilities.get('platformName', '').lower()
        if platform == 'ios':
            try:
                self.driver.hide_keyboard()
            except Exception:
                pass
            # Tap AppBar safe area outside any input/keyboard to dismiss focus
            try:
                window_size = self.driver.get_window_size()
                top_x = int(window_size['width'] * 0.5)
                top_y = 65
                self.driver.execute_script('mobile: tap', {'x': top_x, 'y': top_y})
                time.sleep(0.3)
            except Exception:
                pass
        else:
            try:
                self.driver.hide_keyboard()
            except Exception:
                pass
            try:
                if hasattr(self.driver, 'is_keyboard_shown') and self.driver.is_keyboard_shown():
                    self.driver.press_keycode(4)  # KEYCODE_BACK
            except Exception:
                pass

    def type_text(self, accessibility_id: str, text: str, clear_first: bool = True, hide_keyboard_after: bool = True):
        """Wprowadza tekst do pola tekstowego z obsługą ponawiania przy StaleElementReferenceException."""
        for attempt in range(3):
            try:
                container = self.find_by_accessibility_id(accessibility_id)
                elem = self._get_input_element(container)
                try:
                    elem.click()
                except Exception:
                    pass
                if clear_first:
                    try:
                        elem.clear()
                    except Exception:
                        pass
                elem.send_keys(text)
                break
            except StaleElementReferenceException:
                if attempt == 2:
                    raise
                time.sleep(0.4)
        if hide_keyboard_after:
            self.hide_keyboard()

    def get_text(self, accessibility_id: str, timeout: Optional[int] = None) -> str:
        """Pobiera tekst lub opis elementu."""
        container = self.find_by_accessibility_id(accessibility_id, timeout)
        elem = self._get_input_element(container)
        text = elem.text
        if not text:
            text = container.text
        if not text or text == accessibility_id:
            for attr in ["content-desc", "value", "label", "name"]:
                candidate = elem.get_attribute(attr) or container.get_attribute(attr)
                if candidate and candidate != accessibility_id:
                    text = candidate
                    break
        return text or ""

    def is_displayed(self, accessibility_id: str, timeout: int = 3) -> bool:
        """Sprawdza, czy element jest widoczny na ekranie w zadanym limicie czasu."""
        try:
            elem = self.find_by_accessibility_id(accessibility_id, timeout=timeout)
            return elem.is_displayed()
        except (TimeoutException, NoSuchElementException):
            return False

    def wait_until_visible(self, accessibility_id: str, timeout: Optional[int] = None):
        """Czeka, aż element będzie widoczny na ekranie."""
        wait = WebDriverWait(self.driver, timeout or self.timeout)
        by, value = self._build_locator(accessibility_id)
        return wait.until(
            EC.visibility_of_element_located((by, value))
        )

    def wait_until_invisible(self, accessibility_id: str, timeout: Optional[int] = None):
        """Czeka, aż element zniknie z ekranu."""
        wait = WebDriverWait(self.driver, timeout or self.timeout)
        by, value = self._build_locator(accessibility_id)
        return wait.until(
            EC.invisibility_of_element_located((by, value))
        )

    # --- W3C GESTURES ---

    def swipe(self, start_x: int, start_y: int, end_x: int, end_y: int, duration_ms: int = 300):
        """Wykonuje gest przesunięcia (swipe/drag) za pomocą W3C Actions API."""
        actions = ActionChains(self.driver)
        finger = actions.w3c_actions.add_pointer_input('touch', 'finger')
        finger.create_pointer_move(x=start_x, y=start_y)
        finger.create_pointer_down(button=0)
        finger.create_pause(0.1)
        finger.create_pointer_move(duration=duration_ms, x=end_x, y=end_y)
        finger.create_pointer_up(button=0)
        actions.perform()

    def swipe_up(self, percent: float = 0.5):
        """Przewija ekran w dół (gest palcem w górę)."""
        window_size = self.driver.get_window_size()
        width = window_size['width']
        height = window_size['height']
        if self.is_ios:
            start_x = 8
            start_y = int(height * 0.70)
            end_y = int(height * 0.20)
        else:
            start_x = int(width * 0.20)
            start_y = int(height * 0.70)
            end_y = int(height * 0.25)
        self.swipe(start_x, start_y, start_x, end_y)

    def swipe_down(self, percent: float = 0.5):
        """Przewija ekran w górę (gest palcem w dół)."""
        window_size = self.driver.get_window_size()
        width = window_size['width']
        height = window_size['height']
        if self.is_ios:
            start_x = 8
            start_y = int(height * 0.20)
            end_y = int(height * 0.70)
        else:
            start_x = int(width * 0.20)
            start_y = int(height * 0.25)
            end_y = int(height * 0.70)
        self.swipe(start_x, start_y, start_x, end_y)


    def scroll_to_element(self, accessibility_id: str, max_swipes: int = 8, percent: float = 0.3) -> bool:
        """Przewija ekran w poszukiwaniu elementu w obu kierunkach."""
        self.hide_keyboard()
        try:
            elem = self.find_by_accessibility_id(accessibility_id, timeout=1)
            if elem.is_displayed():
                loc = elem.location
                h = self.driver.get_window_size()['height']
                if loc['y'] > h * 0.75:
                    self.swipe_up(percent=0.25)
                    time.sleep(0.5)
                return True
        except Exception:
            pass
        # Przewijanie w dół (palcem w górę)
        for _ in range(max_swipes):
            self.swipe_up(percent=percent)
            time.sleep(0.4)
            if self.is_displayed(accessibility_id, timeout=1):
                time.sleep(0.7)
                return True
        # Jeśli nie znaleziono, przewijaj w górę (palcem w dół)
        for _ in range(max_swipes):
            self.swipe_down(percent=percent)
            time.sleep(0.4)
            if self.is_displayed(accessibility_id, timeout=1):
                time.sleep(0.7)
                return True
        time.sleep(0.5)
        return self.is_displayed(accessibility_id, timeout=1)

    def double_tap(self, accessibility_id: str):
        """Wykonuje podwójne kliknięcie (double-tap) w element."""
        elem = self.find_by_accessibility_id(accessibility_id)
        location = elem.location
        size = elem.size
        center_x = location['x'] + size['width'] // 2
        center_y = location['y'] + size['height'] // 2

        actions = ActionChains(self.driver)
        finger = actions.w3c_actions.add_pointer_input('touch', 'finger')
        
        finger.create_pointer_move(x=center_x, y=center_y)
        finger.create_pointer_down(button=0)
        finger.create_pause(0.05)
        finger.create_pointer_up(button=0)
        finger.create_pause(0.08)
        finger.create_pointer_down(button=0)
        finger.create_pause(0.05)
        finger.create_pointer_up(button=0)
        
        actions.perform()

    def long_press(self, accessibility_id: str, duration_sec: float = 1.5):
        """Wykonuje długie naciśnięcie elementu (long press)."""
        elem = self.find_by_accessibility_id(accessibility_id)
        location = elem.location
        size = elem.size
        center_x = location['x'] + size['width'] // 2
        center_y = location['y'] + size['height'] // 2

        actions = ActionChains(self.driver)
        finger = actions.w3c_actions.add_pointer_input('touch', 'finger')
        finger.create_pointer_move(x=center_x, y=center_y)
        finger.create_pointer_down(button=0)
        finger.create_pause(duration_sec)
        finger.create_pointer_up(button=0)
        actions.perform()

    def drag_and_drop(self, source_id: str, target_id: str, hold_duration_sec: float = 0.5):
        """Przeciąga element source_id na target_id (drag and drop)."""
        source_elem = self.find_by_accessibility_id(source_id)
        target_elem = self.find_by_accessibility_id(target_id)

        src_loc = source_elem.location
        src_size = source_elem.size
        src_x = src_loc['x'] + src_size['width'] // 2
        src_y = src_loc['y'] + src_size['height'] // 2

        tgt_loc = target_elem.location
        tgt_size = target_elem.size
        tgt_x = tgt_loc['x'] + tgt_size['width'] // 2
        tgt_y = tgt_loc['y'] + tgt_size['height'] // 2

        actions = ActionChains(self.driver)
        finger = actions.w3c_actions.add_pointer_input('touch', 'finger')
        finger.create_pointer_move(x=src_x, y=src_y)
        finger.create_pointer_down(button=0)
        finger.create_pause(hold_duration_sec)
        finger.create_pointer_move(x=tgt_x, y=tgt_y)
        finger.create_pause(0.2)
        finger.create_pointer_up(button=0)
        actions.perform()
