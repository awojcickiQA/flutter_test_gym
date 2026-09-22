from .base_page import BasePage

class AccessibilityPage(BasePage):
    """Page Object dla modułu Dostępność & Edge Cases (a11y)."""
    A11Y_SCREEN = "a11y_screen"
    LANGUAGE_TOGGLE_BTN = "a11y_language_toggle_btn"
    CURRENT_DIRECTION_TEXT = "a11y_current_direction_text"
    HIGH_CONTRAST_TOGGLE = "a11y_high_contrast_toggle"
    SEMANTICS_CARD = "a11y_semantics_card"
    CUSTOM_PAINT_AREA = "a11y_custom_paint_area"

    def is_loaded(self) -> bool:
        return (
            self.is_displayed(self.LANGUAGE_TOGGLE_BTN, timeout=5) or
            self.is_displayed(self.CURRENT_DIRECTION_TEXT, timeout=2) or
            self.is_displayed(self.HIGH_CONTRAST_TOGGLE, timeout=2) or
            self.is_displayed(self.A11Y_SCREEN, timeout=1)
        )

    def toggle_rtl_ltr(self):
        self.click(self.LANGUAGE_TOGGLE_BTN)

    def get_direction_text(self) -> str:
        return self.get_text(self.CURRENT_DIRECTION_TEXT)

    def toggle_high_contrast(self):
        self.click(self.HIGH_CONTRAST_TOGGLE)

    def is_semantics_card_accessible(self) -> bool:
        return self.is_displayed(self.SEMANTICS_CARD, timeout=3)
