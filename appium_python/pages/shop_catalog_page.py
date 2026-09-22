from .base_page import BasePage

class ShopCatalogPage(BasePage):
    """Page Object dla katalogu produktów w sklepie."""
    CATALOG_SCREEN = "shop_catalog_screen"
    SEARCH_INPUT = "shop_catalog_search_input"
    SORT_DROPDOWN = "shop_catalog_sort_dropdown"
    CART_BADGE = "shop_catalog_cart_badge"
    CART_BTN = "shop_catalog_cart_btn"

    def is_loaded(self) -> bool:
        return self.is_displayed(self.SEARCH_INPUT, timeout=5) or self.is_displayed(self.CATALOG_SCREEN, timeout=1)

    def search_product(self, name: str):
        self.type_text(self.SEARCH_INPUT, name)

    def add_product_to_cart(self, product_id: str):
        btn_id = f"shop_product_add_btn_{product_id}"
        self.scroll_to_element(btn_id)
        self.click(btn_id)

    def get_cart_badge_count(self) -> str:
        return self.get_text(self.CART_BADGE)

    def open_cart(self):
        self.click(self.CART_BTN)
