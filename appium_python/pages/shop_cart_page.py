from .base_page import BasePage

class ShopCartPage(BasePage):
    """Page Object dla koszyka sklepowego."""
    CART_SCREEN = "shop_cart_screen"
    COUPON_INPUT = "shop_cart_coupon_input"
    COUPON_APPLY_BTN = "shop_cart_coupon_apply_btn"
    COUPON_BADGE = "shop_cart_coupon_badge"
    SUBTOTAL_TEXT = "shop_cart_subtotal_text"
    DISCOUNT_TEXT = "shop_cart_discount_text"
    TOTAL_TEXT = "shop_cart_total_text"
    CHECKOUT_BTN = "shop_cart_checkout_btn"

    def is_loaded(self) -> bool:
        return self.is_displayed(self.CHECKOUT_BTN, timeout=5) or self.is_displayed(self.COUPON_INPUT, timeout=2) or self.is_displayed(self.CART_SCREEN, timeout=1)

    def increase_quantity(self, product_id: str):
        btn_id = f"shop_cart_qty_increase_{product_id}"
        self.click(btn_id)

    def decrease_quantity(self, product_id: str):
        btn_id = f"shop_cart_qty_decrease_{product_id}"
        self.click(btn_id)

    def remove_item(self, product_id: str):
        btn_id = f"shop_cart_item_delete_{product_id}"
        self.click(btn_id)

    def apply_coupon(self, coupon_code: str):
        self.scroll_to_element(self.COUPON_INPUT)
        self.type_text(self.COUPON_INPUT, coupon_code)
        self.click(self.COUPON_APPLY_BTN)

    def is_coupon_applied(self) -> bool:
        return self.is_displayed(self.COUPON_BADGE, timeout=3)

    def get_total_price(self) -> str:
        self.scroll_to_element(self.TOTAL_TEXT)
        return self.get_text(self.TOTAL_TEXT)

    def proceed_to_checkout(self):
        self.scroll_to_element(self.CHECKOUT_BTN)
        self.click(self.CHECKOUT_BTN)
