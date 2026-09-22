from .base_page import BasePage

class OverlaysPage(BasePage):
    """Page Object dla modułu Dialogi, Nakładki & Powiadomienia."""
    OVERLAYS_SCREEN = "overlays_screen"
    SHOW_ALERT_BTN = "overlays_show_alert_btn"
    ALERT_DIALOG = "overlays_alert_dialog"
    ALERT_OK_BTN = "overlays_alert_ok_btn"

    SHOW_CONFIRM_BTN = "overlays_show_confirm_btn"
    CONFIRM_DIALOG = "overlays_confirm_dialog"
    CONFIRM_YES_BTN = "overlays_confirm_yes_btn"
    CONFIRM_NO_BTN = "overlays_confirm_no_btn"

    SHOW_PROMPT_BTN = "overlays_show_prompt_btn"
    PROMPT_DIALOG = "overlays_prompt_dialog"
    PROMPT_INPUT = "overlays_prompt_input"
    PROMPT_SUBMIT_BTN = "overlays_prompt_submit_btn"

    DIALOG_RESULT_TEXT = "overlays_dialog_result_text"

    SHOW_BOTTOM_SHEET_BTN = "overlays_show_bottom_sheet_btn"
    BOTTOM_SHEET = "overlays_bottom_sheet"
    BOTTOM_SHEET_CLOSE_BTN = "overlays_bottom_sheet_close_btn"

    SHOW_SNACKBAR_BTN = "overlays_show_snackbar_btn"
    SNACKBAR_ACTION_BTN = "overlays_snackbar_action_btn"

    OPEN_DRAWER_BTN = "overlays_open_drawer_btn"
    NAV_DRAWER = "overlays_nav_drawer"

    def is_loaded(self) -> bool:
        return (
            self.is_displayed(self.SHOW_ALERT_BTN, timeout=3) or
            self.is_displayed(self.SHOW_BOTTOM_SHEET_BTN, timeout=1) or
            self.is_displayed(self.OPEN_DRAWER_BTN, timeout=1) or
            self.is_displayed(self.OVERLAYS_SCREEN, timeout=1)
        )

    def trigger_and_accept_alert(self):
        self.click(self.SHOW_ALERT_BTN)
        self.wait_until_visible(self.ALERT_OK_BTN)
        self.click(self.ALERT_OK_BTN)

    def trigger_confirm_dialog(self, accept: bool = True):
        self.click(self.SHOW_CONFIRM_BTN)
        self.wait_until_visible(self.CONFIRM_YES_BTN)
        if accept:
            self.click(self.CONFIRM_YES_BTN)
        else:
            self.click(self.CONFIRM_NO_BTN)

    def trigger_prompt_dialog(self, text_input: str):
        self.click(self.SHOW_PROMPT_BTN)
        self.wait_until_visible(self.PROMPT_INPUT)
        self.type_text(self.PROMPT_INPUT, text_input, hide_keyboard_after=False)
        self.click(self.PROMPT_SUBMIT_BTN)

    def get_dialog_result(self) -> str:
        return self.get_text(self.DIALOG_RESULT_TEXT)

    def open_and_close_bottom_sheet(self):
        self.scroll_to_element(self.SHOW_BOTTOM_SHEET_BTN)
        self.click(self.SHOW_BOTTOM_SHEET_BTN)
        self.wait_until_visible(self.BOTTOM_SHEET_CLOSE_BTN)
        self.click(self.BOTTOM_SHEET_CLOSE_BTN)

    def open_drawer(self):
        self.scroll_to_element(self.OPEN_DRAWER_BTN)
        self.click(self.OPEN_DRAWER_BTN)

    def is_drawer_open(self) -> bool:
        if self.is_displayed(self.NAV_DRAWER, timeout=2):
            return True
        from appium.webdriver.common.appiumby import AppiumBy
        from selenium.webdriver.support.wait import WebDriverWait
        from selenium.webdriver.support import expected_conditions as EC
        by = AppiumBy.XPATH
        val = (
            "//*[contains(@text, 'Boczne Menu') or "
            "contains(@content-desc, 'Boczne Menu') or "
            "contains(@name, 'Boczne Menu') or "
            "contains(@label, 'Boczne Menu') or "
            "contains(@text, 'Powrót') or "
            "contains(@name, 'Powrót') or "
            "contains(@label, 'Powrót')]"
        )
        try:
            WebDriverWait(self.driver, 4).until(EC.presence_of_element_located((by, val)))
            return True
        except Exception:
            return False

    def trigger_snackbar(self):
        self.scroll_to_element(self.SHOW_SNACKBAR_BTN)
        self.click(self.SHOW_SNACKBAR_BTN)

    def is_snackbar_action_visible(self) -> bool:
        return self.is_displayed(self.SNACKBAR_ACTION_BTN, timeout=3)
