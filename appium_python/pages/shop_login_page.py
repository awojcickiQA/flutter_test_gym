from .base_page import BasePage

class ShopLoginPage(BasePage):
    """Page Object dla ekranu logowania do sklepu."""
    SHOP_LOGIN_SCREEN = "shop_login_screen"
    EMAIL_INPUT = "shop_login_email_input"
    PASSWORD_INPUT = "shop_login_password_input"
    REMEMBER_CHECKBOX = "shop_login_remember_checkbox"
    SUBMIT_BTN = "shop_login_submit_btn"
    QUICK_FILL_BTN = "shop_login_quick_fill_btn"
    ERROR_TEXT = "shop_login_error_text"

    def is_loaded(self) -> bool:
        return self.is_displayed(self.EMAIL_INPUT, timeout=5) or self.is_displayed(self.SHOP_LOGIN_SCREEN, timeout=1)

    def login(self, email: str, password: str):
        self.type_text(self.EMAIL_INPUT, email)
        self.type_text(self.PASSWORD_INPUT, password)
        self.click(self.SUBMIT_BTN)

    def quick_fill_and_submit(self):
        self.click(self.QUICK_FILL_BTN)
        self.click(self.SUBMIT_BTN)

    def get_error_message(self) -> str:
        return self.get_text(self.ERROR_TEXT)
