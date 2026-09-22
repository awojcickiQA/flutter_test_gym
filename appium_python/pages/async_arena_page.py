from .base_page import BasePage

class AsyncArenaPage(BasePage):
    """Page Object dla modułu Asynchroniczność & Flakiness."""
    ASYNC_SCREEN = "async_screen"
    FETCH_DATA_BTN = "async_fetch_data_btn"
    LOADING_SPINNER = "async_loading_spinner"
    RESULT_TEXT = "async_result_text"
    ANIMATION_TOGGLE_BTN = "async_animation_toggle_btn"
    INFINITE_ANIMATION = "async_infinite_animation_widget"
    FLAKY_BTN = "async_flaky_btn"
    FLAKY_RETRY_BTN = "async_flaky_retry_btn"
    FLAKY_SUCCESS_BADGE = "async_flaky_success_badge"
    FLAKY_ERROR_BADGE = "async_flaky_error_badge"
    TRIGGER_TOAST_BTN = "async_trigger_toast_btn"
    TRANSIENT_TOAST = "async_transient_toast"

    def is_loaded(self) -> bool:
        return (
            self.is_displayed(self.FETCH_DATA_BTN, timeout=3) or
            self.is_displayed(self.TRIGGER_TOAST_BTN, timeout=1) or
            self.is_displayed(self.ASYNC_SCREEN, timeout=1)
        )

    def fetch_data(self):
        self.click(self.FETCH_DATA_BTN)

    def wait_for_data(self, timeout: int = 10) -> str:
        self.wait_until_visible(self.RESULT_TEXT, timeout=timeout)
        return self.get_text(self.RESULT_TEXT)

    def toggle_animation(self):
        self.click(self.ANIMATION_TOGGLE_BTN)

    def click_flaky_button(self):
        self.scroll_to_element(self.FLAKY_BTN)
        self.click(self.FLAKY_BTN)

    def is_flaky_success(self) -> bool:
        return self.is_displayed(self.FLAKY_SUCCESS_BADGE, timeout=2)

    def is_flaky_error(self) -> bool:
        return self.is_displayed(self.FLAKY_ERROR_BADGE, timeout=2)

    def click_retry_if_needed(self, max_attempts: int = 5) -> bool:
        """Ponawia próbę aż do uzyskania sukcesu."""
        import time
        for _ in range(max_attempts):
            if self.is_flaky_success():
                return True
            if self.is_displayed(self.FLAKY_RETRY_BTN, timeout=1):
                self.click(self.FLAKY_RETRY_BTN)
            else:
                self.click_flaky_button()
            time.sleep(0.8)
        return self.is_flaky_success()

    def trigger_transient_toast(self):
        self.scroll_to_element(self.TRIGGER_TOAST_BTN)
        self.swipe_up(percent=0.25)
        self.click(self.TRIGGER_TOAST_BTN)

    def is_toast_visible(self) -> bool:
        return self.is_displayed(self.TRANSIENT_TOAST, timeout=3)
