from .base_page import BasePage

class ListsPage(BasePage):
    """Page Object dla modułu Listy & Przewijanie."""
    LISTS_SCREEN = "lists_screen"
    SEARCH_INPUT = "lists_search_input"
    SEARCH_CLEAR_BTN = "lists_search_clear_btn"
    ITEM_COUNT_TEXT = "lists_item_count_text"
    INFINITE_LIST = "lists_infinite_list_view"
    EMPTY_STATE = "lists_empty_state"
    LOADING_SPINNER = "lists_loading_more_spinner"

    def is_loaded(self) -> bool:
        return self.is_displayed(self.SEARCH_INPUT, timeout=5) or self.is_displayed(self.LISTS_SCREEN, timeout=1)

    def search(self, query: str):
        self.type_text(self.SEARCH_INPUT, query)

    def clear_search(self):
        self.click(self.SEARCH_CLEAR_BTN)

    def get_item_count_text(self) -> str:
        return self.get_text(self.ITEM_COUNT_TEXT)

    def item_tile_id(self, item_id: int) -> str:
        return f"lists_item_tile_{item_id}"

    def is_item_displayed(self, item_id: int, timeout: int = 2) -> bool:
        return self.is_displayed(self.item_tile_id(item_id), timeout=timeout)

    def scroll_to_item(self, item_id: int, max_swipes: int = 8) -> bool:
        return self.scroll_to_element(self.item_tile_id(item_id), max_swipes=max_swipes)

    def is_empty_state_displayed(self) -> bool:
        return self.is_displayed(self.EMPTY_STATE, timeout=2)
