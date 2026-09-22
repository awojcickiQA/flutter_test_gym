from .base_page import BasePage

class ShopCheckoutPage(BasePage):
    """Page Object dla wielokrokowego procesu kasy (Stepper)."""
    CHECKOUT_SCREEN = "shop_checkout_screen"
    NAME_INPUT = "shop_checkout_name_input"
    STREET_INPUT = "shop_checkout_street_input"
    ZIP_INPUT = "shop_checkout_zip_input"
    CITY_INPUT = "shop_checkout_city_input"

    DELIVERY_COURIER = "shop_checkout_delivery_courier"
    DELIVERY_LOCKER = "shop_checkout_delivery_locker"

    PAYMENT_CARD = "shop_checkout_payment_card"
    PAYMENT_BLIK = "shop_checkout_payment_blik"
    BLIK_CODE_INPUT = "shop_checkout_blik_code_input"

    NEXT_BTN = "shop_checkout_next_btn"
    BACK_BTN = "shop_checkout_back_btn"
    PLACE_ORDER_BTN = "shop_checkout_place_order_btn"

    def is_loaded(self) -> bool:
        return self.is_displayed(self.NAME_INPUT, timeout=5) or self.is_displayed(self.CHECKOUT_SCREEN, timeout=1)

    def fill_address(self, name: str, street: str, zip_code: str, city: str):
        self.type_text(self.NAME_INPUT, name)
        self.type_text(self.STREET_INPUT, street)
        self.type_text(self.ZIP_INPUT, zip_code)
        self.type_text(self.CITY_INPUT, city)

    def click_next(self):
        self.scroll_to_element(self.NEXT_BTN)
        self.click(self.NEXT_BTN)

    def select_delivery_courier(self):
        self.scroll_to_element(self.DELIVERY_COURIER)
        self.click(self.DELIVERY_COURIER)

    def select_delivery_locker(self):
        self.scroll_to_element(self.DELIVERY_LOCKER)
        self.click(self.DELIVERY_LOCKER)

    def select_payment_blik(self, blik_code: str = "123456"):
        self.scroll_to_element(self.PAYMENT_BLIK)
        self.click(self.PAYMENT_BLIK)
        if self.is_displayed(self.BLIK_CODE_INPUT, timeout=2):
            self.type_text(self.BLIK_CODE_INPUT, blik_code)

    def select_payment_card(self):
        self.scroll_to_element(self.PAYMENT_CARD)
        self.click(self.PAYMENT_CARD)

    def place_order(self):
        self.scroll_to_element(self.PLACE_ORDER_BTN)
        self.click(self.PLACE_ORDER_BTN)
