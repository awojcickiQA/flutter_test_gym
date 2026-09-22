from .base_page import BasePage

class TestInspectorPage(BasePage):
    """Page Object dla wbudowanego narzędzia Test Inspector Overlay."""
    __test__ = False  # Zapobiega traktowaniu klasy Page Object jako klasy testowej przez pytest

    INSPECTOR_PANEL = "inspector_overlay_panel"
    CLOSE_BTN = "inspector_close_btn"
    ACTIVE_SCREEN_TEXT = "inspector_active_screen_text"
    KEY_LIST = "inspector_key_list"

    def is_open(self, timeout: int = 2) -> bool:
        return self.is_displayed(self.CLOSE_BTN, timeout=timeout)

    def close(self):
        self.click(self.CLOSE_BTN)

    def get_active_route_name(self) -> str:
        return self.get_text(self.ACTIVE_SCREEN_TEXT)
