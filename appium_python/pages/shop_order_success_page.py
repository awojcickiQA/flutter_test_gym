import re
from .base_page import BasePage

class ShopOrderSuccessPage(BasePage):
    """Page Object dla ekranu potwierdzenia zamówienia (Success Screen)."""
    SUCCESS_SCREEN = "shop_order_success_screen"
    ORDER_ID_TEXT = "shop_order_id_text"
    HOME_BTN = "shop_order_success_home_btn"

    def is_loaded(self) -> bool:
        return self.is_displayed(self.ORDER_ID_TEXT, timeout=5) or self.is_displayed(self.HOME_BTN, timeout=2) or self.is_displayed(self.SUCCESS_SCREEN, timeout=1)

    def get_order_id(self) -> str:
        return self.get_text(self.ORDER_ID_TEXT)

    def is_valid_order_id(self) -> bool:
        order_text = self.get_order_id()
        return bool(re.search(r'ORD-\d+', order_text))

    def return_to_home(self):
        self.click(self.HOME_BTN)
