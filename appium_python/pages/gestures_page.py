from .base_page import BasePage

class GesturesPage(BasePage):
    """Page Object dla modułu Gesty & Interakcje."""
    GESTURES_SCREEN = "gestures_screen"
    SINGLE_TAP_AREA = "gestures_single_tap_area"
    SINGLE_TAP_COUNTER = "gestures_single_tap_counter"
    DOUBLE_TAP_AREA = "gestures_double_tap_area"
    DOUBLE_TAP_COUNTER = "gestures_double_tap_counter"
    LONG_PRESS_AREA = "gestures_long_press_area"
    LONG_PRESS_FEEDBACK = "gestures_long_press_feedback"
    DRAGGABLE_ITEM = "gestures_draggable_item"
    DRAG_TARGET_BIN = "gestures_drag_target_bin"
    DRAG_SCORE_TEXT = "gestures_drag_score_text"
    CANVAS_CLEAR_BTN = "gestures_canvas_clear_btn"

    def is_loaded(self) -> bool:
        return (
            self.is_displayed(self.SINGLE_TAP_AREA, timeout=3) or
            self.is_displayed(self.CANVAS_CLEAR_BTN, timeout=1) or
            self.is_displayed(self.DRAGGABLE_ITEM, timeout=1) or
            self.is_displayed(self.GESTURES_SCREEN, timeout=1)
        )

    def tap_single_area(self):
        self.click(self.SINGLE_TAP_AREA)

    def get_single_tap_count(self) -> str:
        return self.get_text(self.SINGLE_TAP_COUNTER)

    def perform_double_tap(self):
        self.double_tap(self.DOUBLE_TAP_AREA)

    def get_double_tap_count(self) -> str:
        return self.get_text(self.DOUBLE_TAP_COUNTER)

    def perform_long_press(self, duration_sec: float = 1.5):
        self.long_press(self.LONG_PRESS_AREA, duration_sec=duration_sec)

    def get_long_press_feedback(self) -> str:
        return self.get_text(self.LONG_PRESS_FEEDBACK)

    def perform_drag_and_drop(self):
        self.scroll_to_element(self.DRAGGABLE_ITEM)
        self.drag_and_drop(self.DRAGGABLE_ITEM, self.DRAG_TARGET_BIN)

    def get_drag_score(self) -> str:
        return self.get_text(self.DRAG_SCORE_TEXT)

    def clear_canvas(self):
        self.scroll_to_element(self.CANVAS_CLEAR_BTN)
        self.click(self.CANVAS_CLEAR_BTN)
