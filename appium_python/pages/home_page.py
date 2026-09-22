from .base_page import BasePage

class HomePage(BasePage):
    """Page Object dla ekranu głównego (Hub z 8 modułami i narzędziami)."""
    HOME_SCREEN = "home_screen"
    NAV_FORMS = "nav_module_forms"
    NAV_GESTURES = "nav_module_gestures"
    NAV_LISTS = "nav_module_lists"
    NAV_ASYNC = "nav_module_async"
    NAV_OVERLAYS = "nav_module_overlays"
    NAV_SHOP = "nav_module_shop"
    NAV_DEVICE = "nav_module_device"
    NAV_A11Y = "nav_module_accessibility"
    TOGGLE_THEME = "toggle_theme_btn"
    TOGGLE_INSPECTOR = "toggle_inspector_btn"

    def is_loaded(self) -> bool:
        return self.is_displayed(self.NAV_FORMS, timeout=5) or self.is_displayed(self.HOME_SCREEN, timeout=1)

    def open_forms_module(self):
        self.scroll_to_element(self.NAV_FORMS)
        self.click(self.NAV_FORMS)

    def open_gestures_module(self):
        self.scroll_to_element(self.NAV_GESTURES)
        self.click(self.NAV_GESTURES)

    def open_lists_module(self):
        self.scroll_to_element(self.NAV_LISTS)
        self.click(self.NAV_LISTS)

    def open_async_module(self):
        self.scroll_to_element(self.NAV_ASYNC)
        self.click(self.NAV_ASYNC)

    def open_overlays_module(self):
        self.scroll_to_element(self.NAV_OVERLAYS)
        self.click(self.NAV_OVERLAYS)

    def open_shop_module(self):
        self.scroll_to_element(self.NAV_SHOP)
        self.click(self.NAV_SHOP)

    def open_device_module(self):
        self.scroll_to_element(self.NAV_DEVICE)
        self.click(self.NAV_DEVICE)

    def open_accessibility_module(self):
        self.scroll_to_element(self.NAV_A11Y)
        self.swipe_up(percent=0.2)
        import time
        time.sleep(0.5)
        self.click(self.NAV_A11Y)
        time.sleep(0.8)

    def toggle_theme(self):
        self.click(self.TOGGLE_THEME)

    def toggle_inspector(self):
        self.click(self.TOGGLE_INSPECTOR)
